//
//  ProvinceModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 28/10/2024.
//

import Foundation

struct ProvinceModel: Identifiable, Hashable, Codable {
    let id: String
    let name: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }

    enum CodingKeys: String, CodingKey {
        case id, name = "nombre"
    }
}
