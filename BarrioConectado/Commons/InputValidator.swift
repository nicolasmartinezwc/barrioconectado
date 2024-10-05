//
//  InputValidator.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 05/10/2024.
//

import Foundation

struct InputValidator {
    enum InputValidatorResult {
        case valid, invalid(String)
    }

    // MARK: Exposed validators

    func validateLogIn(
        email: String,
        password: String
    ) -> InputValidatorResult {
        return evaluateValidationResults([
            validateEmail(email: email),
            validatePassword(password: password)
        ])
    }

    func validateSignUp(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) -> InputValidatorResult {
        evaluateValidationResults([
            validateFirstName(firstName: firstName),
            validateLastName(lastName: lastName),
            validateEmail(email: email),
            validatePassword(password: password)
        ])
    }

    // MARK: Evaluator

    private func evaluateValidationResults(_ results: [InputValidatorResult]) -> InputValidatorResult {
        for result in results {
            if case .invalid(let errorMessage) = result {
                return .invalid(errorMessage)
            }
        }
        return .valid
    }

    // MARK: Private validators

    func validateEmail(email: String) -> InputValidatorResult {
        guard !email.isEmpty else {
            return .invalid("Ingresa tu e-mail.")
        }
    
        guard email.count >= 10 else {
            return .invalid("El e-mail debe tener al menos 10 caracteres.")
        }

        guard email.count <= 50 else {
            return .invalid("El e-mail debe tener menos de 50 caracteres.")
        }

        return .valid
    }

    private func validatePassword(password: String) -> InputValidatorResult {
        guard !password.isEmpty else {
            return .invalid("Ingresa una contraseña.")
        }

        guard password.count >= 6 else {
            return .invalid("La contraseña debe tener al menos 6 caracteres.")
        }

        guard password.count < 20 else {
            return .invalid("La contraseña debe tener menos de 20 caracteres.")
        }

        return .valid
    }

    private  func validateFirstName(firstName: String)  -> InputValidatorResult {
        guard !firstName.isEmpty else {
            return .invalid("Ingresa tu nombre.")
        }

        guard firstName.count >= 3 else {
            return .invalid("El nombre debe tener al menos 3 caracteres.")
        }

        guard firstName.count <= 20 else {
            return .invalid("El nombre debe tener menos de 20 caracteres.")
        }

        return .valid
    }

    private func validateLastName(lastName: String)  -> InputValidatorResult {
        guard !lastName.isEmpty else {
            return .valid
        }

        guard lastName.count >= 3 else {
            return .invalid("El apellido debe tener al menos 3 caracteres.")
        }

        guard lastName.count <= 20 else {
            return .invalid("El apellido debe tener menos de 20 caracteres.")
        }

        return .valid
    }
}
