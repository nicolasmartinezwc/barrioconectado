//
//  AuthManager.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 25/09/2024.
//

import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseCore

class AuthManager: ObservableObject {

    private var auth: Auth = Auth.auth()

    public static let instance = AuthManager()

    @Published var hasSession: Bool = false

    var currentUserUID: String? {
        auth.currentUser?.uid
    }

    private init() {}

    /// Updates the current auth status and starts a listener to know if the user lost its session at any time.
    @MainActor
    func initializeStatus() {
        checkSessionStatus()
        listenForAuthChanges()
    }

    /// Checks if the user is currently authenticated and fetches user data if so.
    @MainActor 
    private func checkSessionStatus() {
        guard auth.currentUser?.uid != nil else {
            return logOut()
        }
        hasSession = true
    }

    /// Starts a listener for authentication state changes.
    @MainActor
    private func listenForAuthChanges() {
        _ = auth.addStateDidChangeListener { [weak self] auth, user in
            self?.hasSession = user != nil
        }
    }


    // MARK: Log out

    /// Logs out the user.
    func logOut() {
        try? auth.signOut()
    }

    // MARK: Restore password

    /// Sends an e-mail to the provided e-mail direction so the user can restore its password.
    func sendPasswordReset(
        to email: String
    ) async -> Result<String, Error> {
        do {
            try await auth.sendPasswordReset(withEmail: email)
            return .success(email)
        } catch {
            return .failure(error)
        }
    }

    // MARK: Sign up

    /// Creates a user with the provided information.
    /// - Parameter email: The email fo the user.
    /// - Parameter password: The password of the user.
    /// - Parameter firstName: The name of the user.
    /// - Parameter lastName: The last name of the user, if any
    /// - Returns: An error if any occurred.
    func createUser(
        email: String,
        password: String,
        firstName: String,
        lastName: String?
    ) async -> Result<UserDataModel, Error> {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let userData = UserDataModel(
                id: result.user.uid,
                email: email,
                firstName: firstName,
                lastName: lastName
            )
            return await DatabaseManager.instance.createUser(userData: userData)
        } catch {
            return .failure(error)
        }
    }

    // MARK: Log in

    /// Logs in the user with the provided credentials.
    /// - Parameter email: The email fo the user.
    /// - Parameter password: The password of the user.
    /// - Returns: An error if any occurred.
    @MainActor
    func logInWithCredentials(
        email: String,
        password: String
    ) async -> Result<UserDataModel, Error> {
        do {
            let authSignInResult = try await auth.signIn(withEmail: email, password: password)
            return await DatabaseManager.instance.searchUserData(for: authSignInResult.user.uid)
        } catch {
            if hasSession {
                logOut() // Logout in case an error ocurred while searching the user's data
            }
            return .failure(error)
        }
    }

    @MainActor
    private func logInWithGoogle() async -> Result<GIDGoogleUser, Error> {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Could not find a clientID while trying to log in with Google Sign In.")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.getRootViewController())
            guard let idToken = result.user.idToken?.tokenString else {
                fatalError("Could not find an id token from Google Sign In.")
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
            try await auth.signIn(with: credential)
            return .success(result.user)
        } catch {
            return .failure(error)
        }
    }

    /// Logs in the user using the Google login provider or creates one if is the first time it logs in.
    @MainActor
    func startLoginWithGoogleFlow() async -> Result<UserDataModel, Error> {
        let logInWithGoogleResult = await logInWithGoogle()
        switch logInWithGoogleResult {
        case .success(let googleUser):
            return await createUserFromGoogle(with: googleUser)
        case .failure(let error):
            logOut()
            return .failure(error)
        }
    }

    func createUserFromGoogle(
        with googleUser: GIDGoogleUser
    ) async -> Result<UserDataModel, Error> {
        guard auth.currentUser != nil
        else {
            return .failure(AuthenticaitonError.ErrorWhileLogginInWithGoogle)
        }
        guard let currentUserUID
        else {
            return .failure(AuthenticaitonError.UserIdentifierIsNil)
        }
        let userData = await DatabaseManager.instance.searchUserData(for: currentUserUID)
        switch userData {
        case .success(let userData):
            return .success(userData)
        case .failure(_):
            guard let userProfile = googleUser.profile
            else {
                fatalError("Error while retriving user's profile data from Google Sign In.")
            }
            guard let firstName = userProfile.givenName
            else {
                fatalError("Error while retriving user's profile data from Google Sign In.")
            }
            let userData = UserDataModel(
                id: currentUserUID,
                email: userProfile.email,
                firstName: firstName,
                lastName: userProfile.familyName ?? ""
            )
            return await DatabaseManager.instance.createUser(userData: userData)
        }
    }
}
