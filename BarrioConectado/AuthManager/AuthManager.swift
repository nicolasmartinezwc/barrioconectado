//
//  AuthManager.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 25/09/2024.
//

import FirebaseAuth
import GoogleSignIn
import Firebase

class AuthManager: ObservableObject {

    private var auth: Auth = Auth.auth()

    public static let instance = AuthManager()
    
    @Published var hasSession: Bool = false

    var currentUserUID: String? {
        auth.currentUser?.uid
    }

    private init() {}

    /// Updates the current auth status and starts a listener to know if the user lost its session at any time.
    func initializeStatus() {
        hasSession = auth.currentUser != nil
        _ = auth.addStateDidChangeListener { [weak self] auth, user in
            self?.hasSession = user != nil
        }
    }

    // MARK: SIGN OUT

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

    // MARK: SIGN UP

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
    ) async -> Result<UserDataModel,Error> {
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

    // MARK: LOG IN

    /// Logs in the user with the provided credentials.
    /// - Parameter email: The email fo the user.
    /// - Parameter password: The password of the user.
    /// - Returns: An error if any occurred.
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

    /// Logs in the user using the Google login provider or creates one if is the first time it logs in.
    func logInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Could not find a clientID while trying to log in with Google Sign In.")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        Task { @MainActor [weak self] in
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.getRootViewController())
                
                guard let idToken = result.user.idToken?.tokenString else {
                    fatalError("Could not find an id token from Google Sign In.")
                }
                
                let user = result.user
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )
                
                let userData = await DatabaseManager.instance.searchUserData(for: result.user.userID!)
                
                if userData != nil {
                    // ya existe el user, completar el login
                    print("completar login")
                } else {
                    // no existe el user, crear datos en la DB
                    guard let userProfileData = user.profile,
                          let firstName = user.profile?.givenName else {
                        fatalError("Error while retriving user's profile data from Google Sign In.")
                    }
                    
                    guard let currentUserUID = self?.currentUserUID else {
                        fatalError("Error while retriving currentUserUID when its supossed to exist.")
                    }
                    
                    let userDataModel = UserDataModel(
                        id: currentUserUID,
                        email: userProfileData.email,
                        firstName: firstName,
                        lastName: userProfileData.familyName ?? ""
                    )
                    
                  /*  let result = await DatabaseManager.instance.createUserData(with: userDataModel)
                    
                    switch result {
                    case .success(_):
                        // si es success enviar a elegir barrio
                        return
                    case .failure(_):
                        // handlear el failure
                        return
                    }*/
                }
            }
            catch {
                print(error)
            }
        }
    }
}
