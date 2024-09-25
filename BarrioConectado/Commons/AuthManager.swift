//
//  AuthManager.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 25/09/2024.
//

import FirebaseAuth
import GoogleSignIn

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
    
    
}
