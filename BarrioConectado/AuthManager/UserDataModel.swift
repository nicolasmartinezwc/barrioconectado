//
//  UserDataModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/09/2024.
//

import Foundation

struct UserDataModel: Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String?
}
