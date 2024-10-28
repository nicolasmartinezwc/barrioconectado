//
//  ProvincesDecoder.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 28/10/2024.
//

import Foundation

struct ProvincesDecoder: Decodable {
    let provinces: [ProvinceModel]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.provinces = try container.decode([ProvinceModel].self, forKey: .provinces)
    }

    private enum CodingKeys: String, CodingKey {
        case provinces = "provincias"
    }
}
