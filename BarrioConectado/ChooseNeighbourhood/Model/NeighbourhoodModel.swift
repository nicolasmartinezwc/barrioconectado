//
//  NeighbourhoodModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 28/10/2024.
//

import Foundation

struct NeighbourhoodModel: Hashable, Identifiable, Codable {
    let id: String
    let name: String
    let population: Int
    let provinceId: String
    let province: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.population = try container.decodeIfPresent(Int.self, forKey: .population) ?? 0
        self.province = try container.decodeIfPresent(String.self, forKey: .province) ?? ""
        self.provinceId = try container.decodeIfPresent(String.self, forKey: .provinceId) ?? ""

        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        } else {
            let spanishContainer = try decoder.container(keyedBy: SpanishCodingKeys.self)
            self.name = try spanishContainer.decodeIfPresent(String.self, forKey: .nombre) ?? ""
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, population, name, province
        case provinceId = "province_id"
    }

    enum SpanishCodingKeys: String, CodingKey {
        case nombre
    }
}
