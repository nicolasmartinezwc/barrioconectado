//
//  NeighbourhoodsDecoder.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 28/10/2024.
//

import Foundation

struct NeighbourhoodsDecoder: Decodable {
    let neighbourhoods: [NeighbourhoodModel]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.neighbourhoods = try container.decode([NeighbourhoodModel].self, forKey: .neighbourhoods)
    }

    private enum CodingKeys: String, CodingKey {
        case neighbourhoods = "municipios"
    }
}
