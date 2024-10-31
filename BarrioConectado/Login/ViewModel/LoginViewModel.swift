//
//  LoginViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 05/10/2024.
//

import Foundation

class LoginViewModel: ObservableObject {
    private let inputValidator = InputValidator()
    @Published var errorMessage: String?
    @Published var isLoginRunning = false
 
    @MainActor
    func logInWithCredentials(
        email: String,
        password: String
    ) {
        if errorMessage != nil {
            return
        }
        
        if case let .invalid(reason) = inputValidator.validateLogIn(
            email: email,
            password: password
        ) {
            return showErrorMessage(reason)
        }
        
        isLoginRunning = true
        Task { [weak self] in
            let result = await AuthManager.instance.logInWithCredentials(email: email, password: password)
            switch result {
            case .success(_):
                // Handle success
                return
            case .failure(let error):
                self?.showErrorMessage(error.spanishDescription)
            }
            self?.isLoginRunning = false
        }
    }

    @MainActor
    func startLoginWithGoogleFlow() {
        isLoginRunning = true
        Task { [weak self] in
            let result = await AuthManager.instance.startLoginWithGoogleFlow()
            switch result {
            case .success(_):
                // Handle success
                return
            case .failure(let error):
                self?.showErrorMessage(error.spanishDescription)
            }
            self?.isLoginRunning = false
        }
    }

    func showErrorMessage(_ message: String) {
        errorMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.errorMessage = nil
        }
    }
}
