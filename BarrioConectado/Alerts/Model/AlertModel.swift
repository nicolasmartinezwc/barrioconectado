//
//  AlertModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 03/11/2024.
//

import Foundation

struct AlertModel: Decodable, Identifiable {
    let id, location, creator, creatorName, description, neighbourhood: String
    let createdAt: Date
    let category: AlertCategory

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.location = try container.decode(String.self, forKey: .location)
        self.creator = try container.decode(String.self, forKey: .creator)
        self.creatorName = try container.decode(String.self, forKey: .creatorName)
        self.neighbourhood = try container.decode(String.self, forKey: .neighbourhood)
        self.description = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(AlertCategory.self, forKey: .category)
        let createdAt = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: createdAt)
    }

    init(id: String, location: String, neighbourhood: String, creator: String, creatorName: String, description: String, createdAt: Date, category: AlertCategory) {
        self.id = id
        self.location = location
        self.creator = creator
        self.creatorName = creatorName
        self.description = description
        self.createdAt = createdAt
        self.category = category
        self.neighbourhood = neighbourhood
    }

    enum CodingKeys: String, CodingKey {
        case id, location, creator, description, category, neighbourhood
        case createdAt = "created_at"
        case creatorName = "creator_name"
    }
}

enum AlertCategory: String, Decodable, CaseIterable {
    case theft, emergency
    
    var spanishName: String {
        switch self {
        case .theft:
            return "Robo"
        case .emergency:
            return "Emergencia"
        }
    }
}
