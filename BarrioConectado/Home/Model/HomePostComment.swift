//
//  HomePostComment.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/10/2024.
//

import Foundation

struct HomePostComment: Codable, Identifiable {
    let id: String
    let post: String
    let text: String
    let ownerPictureUrl: String
    let owner: String
    let ownerName: String
    let createdAt: Date
    var amountOfLikes: Int
    var likedBy: [String]

    var liked: Bool {
        guard let uid = AuthManager.instance.currentUserUID else { return false }
        return likedBy.contains { $0 == uid }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.post = try container.decode(String.self, forKey: .post)
        self.text = try container.decode(String.self, forKey: .text)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.ownerPictureUrl = try container.decode(String.self, forKey: .ownerPictureUrl)
        self.ownerName = try container.decode(String.self, forKey: .ownerName)
        let createdAt = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAt))
        self.likedBy = try container.decode([String].self, forKey: .likedBy)
        self.amountOfLikes = try container.decode(Int.self, forKey: .amountOfLikes)
    }

    enum CodingKeys: String, CodingKey {
        case id, post, text, owner
        case likedBy = "liked_by"
        case amountOfLikes = "amount_of_likes"
        case ownerPictureUrl = "owner_picture_url"
        case ownerName = "owner_name"
        case createdAt = "created_at"
    }
}
