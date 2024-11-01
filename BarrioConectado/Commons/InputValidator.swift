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

    func validateEventData(
        title: String,
        description: String,
        location: String,
        day: Int,
        month: Int,
        year: Int
    ) -> InputValidatorResult {
        evaluateValidationResults([
            validateEventTitle(title: title),
            validateEventDescription(description: description),
            validateEventLocation(location: location),
            validateEventDate(day: day, month: month, year: year)
        ])
    }

    func validateUserDescription(
        description: String
    ) -> InputValidatorResult {
        guard !description.isEmpty else {
            return .invalid("La descripción no puede estar vacía.")
        }

        guard description.count >= 3 else {
            return .invalid("La descripción debe tener al menos 3 caracteres.")
        }

        guard description.count < 100 else {
            return .invalid("La descripción debe tener menos de 100 caracteres.")
        }

        return .valid
    }

    func validatePost(
        post: String
    ) -> InputValidatorResult {
        guard !post.isEmpty else {
            return .invalid("El post no puede estar vacío.")
        }

        guard post.count >= 3 else {
            return .invalid("La descripción debe tener al menos 3 caracteres.")
        }

        guard post.count < 300 else {
            return .invalid("La descripción debe tener menos de 300 caracteres.")
        }

        return .valid
    }

    func validateComment(
        comment: String
    ) -> InputValidatorResult {
        guard !comment.isEmpty else {
            return .invalid("El comentario no puede estar vacío.")
        }

        guard comment.count >= 3 else {
            return .invalid("El comentario debe tener al menos 3 caracteres.")
        }

        guard comment.count < 300 else {
            return .invalid("El comentario debe tener menos de 300 caracteres.")
        }

        return .valid
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
    
    
    // MARK: Event validations

    func validateEventTitle(title: String) -> InputValidatorResult {
        guard !title.isEmpty else {
            return .invalid("El título del evento no puede estar vacío.")
        }

        guard title.count >= 6 else {
            return .invalid("El título debe tener al menos 6 caracteres.")
        }

        guard title.count < 50 else {
            return .invalid("El título debe tener menos de 50 caracteres.")
        }

        return .valid
    }
    
    func validateEventDescription(description: String) -> InputValidatorResult {
        guard !description.isEmpty else {
            return .invalid("La descripción del evento no puede estar vacía.")
        }

        guard description.count >= 10 else {
            return .invalid("La descripción debe tener al menos 10 caracteres.")
        }

        guard description.count < 100 else {
            return .invalid("La descripción debe tener menos de 100 caracteres.")
        }

        return .valid
    }

    func validateEventLocation(location: String) -> InputValidatorResult {
        guard !location.isEmpty else {
            return .invalid("La ubicación del evento no puede estar vacía.")
        }

        guard location.count >= 6 else {
            return .invalid("La descripción debe tener al menos 6 caracteres.")
        }

        guard location.count < 100 else {
            return .invalid("La ubicación debe tener menos de 100 caracteres.")
        }

        return .valid
    }

    func validateEventDate(
        day: Int,
        month: Int,
        year: Int
    ) -> InputValidatorResult {
        let dateComponents = DateComponents(year: year, month: month, day: day)

        guard let selectedDate = Calendar.current.date(from: dateComponents) else {
            return .invalid("La fecha no es válida.")
        }

        let today = Calendar.current.startOfDay(for: Date())

        if Calendar.current.startOfDay(for: selectedDate) < today {
            return .invalid("La fecha elegida debe ser de hoy o de un día posterior.")
        }

        if year > today.components.year! + 1 {
            return .invalid("Solo se pueden crear eventos de este año o del año siguiente.")
        }

        return .valid
    }
}
