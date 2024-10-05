//
//  RestorePasswordViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 05/10/2024.
//

import Foundation

class RestorePasswordViewModel: ObservableObject {
    private let inputValidator = InputValidator()
    @Published var snackBarModel: SnackBarModel?
    @Published var isRestoringRunning = false

    @MainActor
    func restorePassword(for email: String) {
        if snackBarModel != nil {
            return
        }

        if case let .invalid(reason) = inputValidator.validateEmail(email: email) {
            return showErrorMessage(reason)
        }

        isRestoringRunning = true
        Task { [weak self] in
            let result = await DatabaseManager.instance.checkIfEmailExists(email: email)
            switch result {
            case .success(let email):
                await self?.sendPasswordReset(to: email)
            case .failure(let error):
                self?.showErrorMessage(error.spanishDescription)
            }
            self?.isRestoringRunning = false
        }
    }

    private func sendPasswordReset(to email: String) async {
        let result = await AuthManager.instance.sendPasswordReset(to: email)
        switch result {
        case .success(_):
            self.showSuccessMessage(email)
        case .failure(let error):
            self.showErrorMessage(error.spanishDescription)
        }
    }

    private func showSuccessMessage(_ message: String) {
        snackBarModel = SnackBarModel(
            text: "Te envíamos un correo para que restablezcas tu contraseña.",
            color: .green
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.snackBarModel = nil
        }
    }

    private func showErrorMessage(_ message: String) {
        snackBarModel = SnackBarModel(
            text: message,
            color: .red
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.snackBarModel = nil
        }
    }
}
