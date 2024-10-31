//
//  HomePostModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import Foundation
import FirebaseFirestore

struct HomePostModel: Decodable, Identifiable {
    let id: String
    let text: String
    var amountOfLikes: Int
    var amountOfComments: Int
    var likedBy: [String]
    let owner: String
    let neighbourhood: String
    let createdAt: Date
    let ownerName: String
    let ownerPictureUrl: String?

    var liked: Bool {
        guard let uid = AuthManager.instance.currentUserUID else { return false }
        return likedBy.contains { $0 == uid }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.neighbourhood = try container.decode(String.self, forKey: .neighbourhood)
        self.likedBy = try container.decode([String].self, forKey: .likedBy)
        self.amountOfLikes = try container.decode(Int.self, forKey: .amountOfLikes)
        self.amountOfComments = try container.decode(Int.self, forKey: .amountOfComments)
        let createdAt = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAt))
        self.ownerName = try container.decode(String.self, forKey: .ownerName)
        self.ownerPictureUrl = try container.decodeIfPresent(String.self, forKey: .ownerPictureUrl)
    }

    init(
        id: String,
        text: String,
        amountOfLikes: Int,
        amountOfComments: Int,
        likedBy: [String],
        owner: String,
        neighbourhood: String,
        createdAt: Date,
        ownerName: String,
        ownerPictureUrl: String?
    ) {
        self.id = id
        self.text = text
        self.amountOfLikes = amountOfLikes
        self.amountOfComments = amountOfComments
        self.likedBy = likedBy
        self.owner = owner
        self.neighbourhood = neighbourhood
        self.createdAt = createdAt
        self.ownerName = ownerName
        self.ownerPictureUrl = ownerPictureUrl
    }

    enum CodingKeys: String, CodingKey {
        case id, text, owner, neighbourhood
        case ownerName = "owner_name"
        case ownerPictureUrl = "owner_picture_url"
        case createdAt = "created_at"
        case likedBy = "liked_by"
        case amountOfLikes = "amount_of_likes"
        case amountOfComments = "amount_of_comments"
    }
}
