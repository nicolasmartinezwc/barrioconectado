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

    func initializeStatus() {
        hasSession = auth.currentUser != nil
        _ = auth.addStateDidChangeListener { [weak self] auth, user in
            self?.hasSession = user != nil
        }
    }

    // MARK: SIGN OUT
    func signOut() {
        try? auth.signOut()
    }

    // MARK: LOG IN
    func logIn() {
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
                
                let userData = await DatabaseManager.instance.searchUserData(for: result.user.userID)
                
                if let userData {
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
                    
                    let result = await DatabaseManager.instance.createUserData(with: userDataModel)
                    
                    switch result {
                    case .success(_):
                        // si es success enviar a elegir barrio
                        return
                    case .failure(_):
                        // handlear el failure
                        return
                    }
                }
            }
            catch {
                print(error)
            }
        }
    }
}
