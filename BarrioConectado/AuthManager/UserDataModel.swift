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
    let description: String
    let provinceId: String?
    let pictureUrl: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.neighbourhood = try container.decodeIfPresent(String.self, forKey: .neighbourhood)
        self.provinceId = try container.decodeIfPresent(String.self, forKey: .provinceId)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.pictureUrl = try container.decodeIfPresent(String.self, forKey: .pictureUrl) ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id, email, neighbourhood, description
        case pictureUrl = "picture_url"
        case firstName = "first_name"
        case lastName = "last_name"
        case provinceId = "province_id"
    }

    // MARK: Memberwise init
    init(
        id: String,
        email: String,
        firstName: String,
        lastName: String? = "",
        neighbourhood: String? = "",
        provinceId: String = "",
        description: String = "",
        pictureUrl: String? = ""
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.neighbourhood = neighbourhood
        self.provinceId = provinceId
        self.description = description
        self.pictureUrl = pictureUrl
    }
}
