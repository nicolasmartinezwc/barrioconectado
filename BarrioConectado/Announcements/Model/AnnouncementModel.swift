//
//  AnnouncementModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 01/11/2024.
//

import SwiftUI

struct AnnouncementModel: Decodable, Identifiable, Equatable {
    var id: String
    let title: String
    let description: String
    let category: AnnouncementCategory
    let owner: String
    let ownerName: String
    let ownerEmail: String
    let createdAt: Date
    let contactPhone: String?
    let neighbourhood: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(AnnouncementCategory.self, forKey: .category)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.neighbourhood = try container.decode(String.self, forKey: .neighbourhood)
        self.ownerName = try container.decode(String.self, forKey: .ownerName)
        self.ownerEmail = try container.decode(String.self, forKey: .ownerEmail)
        self.contactPhone = try container.decodeIfPresent(String.self, forKey: .contactPhone)
        let createdAt = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: createdAt)
    }

    init(id: String, title: String, description: String, category: AnnouncementCategory, owner: String, ownerName: String, ownerEmail: String, createdAt: Date, contactPhone: String? = nil, neighbourhood: String) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.owner = owner
        self.ownerName = ownerName
        self.ownerEmail = ownerEmail
        self.createdAt = createdAt
        self.contactPhone = contactPhone
        self.neighbourhood = neighbourhood
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, category, owner, neighbourhood
        case ownerName = "owner_name"
        case ownerEmail = "owner_email"
        case createdAt = "created_at"
        case contactPhone = "contact_phone"
    }
}

struct AnnouncementCategoryInformation {
    let spanishName: String
    let iconName: String
    let iconColor: Color
    let iconBackgroundColor: Color
}

enum AnnouncementCategory: String, Codable, CaseIterable {
    case job, exchange, donation

    var information: AnnouncementCategoryInformation {
        switch self {
        case .job:
           return AnnouncementCategoryInformation(
            spanishName: "Trabajo",
            iconName: "hammer.fill",
            iconColor: Color(hex: "#a4db8f"),
            iconBackgroundColor: Color(hex: "#3a6e26")
           )
        case .exchange:
            return AnnouncementCategoryInformation(
             spanishName: "Intercambio",
             iconName: "rectangle.2.swap",
             iconColor: Color(hex: "#d6db8f"),
             iconBackgroundColor: Color(hex: "#4c4f1d")
            )
        case .donation:
            return AnnouncementCategoryInformation(
             spanishName: "Donación",
             iconName: "gift.fill",
             iconColor: Color(hex: "#bf98d6"),
             iconBackgroundColor: Color(hex: "#331047")
            )
        }
    }
}
