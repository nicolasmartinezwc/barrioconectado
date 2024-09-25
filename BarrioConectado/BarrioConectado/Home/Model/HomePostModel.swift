//
//  HomePostModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import Foundation

struct HomePostModel: Decodable, Identifiable {
    let id: UUID = UUID()    
    let text: String
    let amountOfLikes: Int
    let amountOfComments: Int
    let liked: Bool

    enum CodingKeys: String, CodingKey {
        case text, liked
        case amountOfLikes = "amount_of_likes"
        case amountOfComments = "amount_of_comments"
    }
}
