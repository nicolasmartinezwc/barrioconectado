//
//  Error+Extension.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 01/10/2024.
//

import Foundation

extension Error {
    var spanishDescription: String {
        if let databaseError = self as? DatabaseError {
            return databaseError.spanishDescription
        }

        switch localizedDescription {
        case "The password must be 6 characters long or more.":
            return "La contraseña debe tener al menos 6 caracteres."
        case "The email address is already in use by another account.":
            return "El correo ya está siendo utilizado por otra cuenta."
        case "The email address is badly formatted.":
            return "El e-mail está mal escrito."
        case "The supplied auth credential is malformed or has expired.":
            return "Alguno de los datos ingresados es incorrecto."
        case "The user account has been disabled by an administrator.":
            return "Tu cuenta ha sido deshabilitada."
        default:
            return "Ocurrió un error."
        }
    }
}

enum DatabaseError: Error {
    case UserNotFoundWithId(String)
    case UserWithEmailNotFound(String)

    var spanishDescription: String {
        switch self {
        case .UserNotFoundWithId(_):
            return "No se encontró el usuario."
        case .UserWithEmailNotFound(let email):
            return "No se encontró un usuario con el correo \(email)."
        }
    }
}
