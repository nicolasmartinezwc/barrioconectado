//
//  SignUpViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 05/10/2024.
//

import Foundation

class SignUpViewModel: ObservableObject {
    private let inputValidator = InputValidator()
    @Published var errorMessage: String?
    @Published var isSignUpRunning = false

    @MainActor
    func createUser(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) {
        if errorMessage != nil {
            return
        }

        if case let .invalid(reason) = inputValidator.validateSignUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        ) {
            return showErrorMessage(reason)
        }

        isSignUpRunning = true
        Task { [weak self] in
            let result = await AuthManager.instance.createUser(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
            switch result {
            case .success(_):
                // handle success
                return
            case .failure(let error):
                self?.showErrorMessage(error.spanishDescription)
            }
            self?.isSignUpRunning = false
        }
    }

    func showErrorMessage(_ message: String) {
        errorMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.errorMessage = nil
        }
    }
}
