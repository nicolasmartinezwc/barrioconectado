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

        if let bcError = self as? BCError {
            return bcError.spanishDescription
        }

        if let networkingError = self as? BCNetworkingError {
            return networkingError.spanishDescription
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

enum BCError: Error {
    case EmptyProvinces
    case EmptyNeighbourhoods(String)
    case UploadedImageIsNil
    case ImageLoadFailed
    case NotAllowedImageType
    case ImageSizeIsBiggerThan10MB
    case ErrorWhileDownloadingImage
    case ImageIsEmpty

    var spanishDescription: String {
        switch self {
        case .EmptyProvinces:
            return "No se encontraron provincias."
        case .EmptyNeighbourhoods(let province):
            return "No se encontraron barrios en \(province)."
        case .ImageLoadFailed:
            return "Ocurrió un error al importar la imagen."
        case .NotAllowedImageType:
            return "El archivo debe ser de tipo .JPEG o .PNG"
        case .UploadedImageIsNil:
            return "La imagen está vacía."
        case .ImageSizeIsBiggerThan10MB:
            return "El tamaño de la imagen debe ser menor a 10 MB."
        case .ErrorWhileDownloadingImage:
            return "Ocurrió un error al descargar la imagen."
        case .ImageIsEmpty:
            return ""
        }
    }
}

enum DatabaseError: Error {
    case UserNotFound
    case UserNotFoundWithId(String)
    case UserWithEmailNotFound(String)
    case ErrorWhileRegisteringNeighbourhood
    case ErrorWhileRegisteringEvent
    case NeighbourhoodNotFound

    var spanishDescription: String {
        switch self {
        case .UserNotFoundWithId(_):
            return "No se encontró el usuario."
        case .UserWithEmailNotFound(let email):
            return "No se encontró un usuario con el correo \(email)."
        case .ErrorWhileRegisteringNeighbourhood:
            return "Ocurrió un error al registrar el barrio."
        case .NeighbourhoodNotFound:
            return "No se encontró el barrio."
        case .UserNotFound:
            return "No se encontró el usuario."
        case .ErrorWhileRegisteringEvent:
            return "Ocurrió un error al crear el evento."
        }
    }
}

enum BCNetworkingError: Error {
    case StatusCodeError(Int)
    case DefaultError

    var spanishDescription: String {
        switch self {
        case .StatusCodeError(let code):
            return "Ocurrió un error: \(code)."
        case .DefaultError:
            return "Ocurrió un error al conectarse con el servidor."
        }
    }
}

enum AuthenticaitonError: Error {
    case UserIdentifierIsNil
    case ErrorWhileLogginInWithGoogle

    var spanishDescription: String {
        switch self {
        case .UserIdentifierIsNil:
            return "Ocurrió un error al cargar la información del usuario."
        case .ErrorWhileLogginInWithGoogle:
            return "Ocurrió un error al iniciar sesión."
        }
    }
}
