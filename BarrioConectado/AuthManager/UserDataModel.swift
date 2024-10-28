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
    let neighbourhood: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.neighbourhood = try container.decodeIfPresent(String.self, forKey: .neighbourhood)
    }

    enum CodingKeys: String, CodingKey {
        case id, email, neighbourhood
        case firstName = "first_name"
        case lastName = "last_name"
    }

    // MARK: Memberwise init
    init(
        id: String,
        email: String,
        firstName: String,
        lastName: String? = "",
        neighbourhood: String? = ""
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.neighbourhood = neighbourhood
    }
}
