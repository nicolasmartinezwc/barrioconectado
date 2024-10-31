//
//  DatabaseManager.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/09/2024.
//

import Firebase

class DatabaseManager {
    static let instance = DatabaseManager()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: Read
    
    func checkIfEmailExists(email: String) async -> Result<String, Error> {
        do {
            guard try await db.collection("users")
                .whereField("email", isEqualTo: email)
                .getDocuments()
                .documents
                .first != nil
            else {
                return .failure(DatabaseError.UserWithEmailNotFound(email))
            }
            return .success(email)
        } catch {
            return .failure(error)
        }
    }
    
    func searchUserData(for uid: String) async -> Result<UserDataModel, Error> {
        do {
            guard let resultAsDictionary = try await db.collection("users")
                .document(uid)
                .getDocument()
                .data()
            else {
                return .failure(DatabaseError.UserNotFoundWithId(uid))
            }
            let resultAsJson = try JSONSerialization.data(withJSONObject: resultAsDictionary)
            let userData = try JSONDecoder().decode(UserDataModel.self, from: resultAsJson)
            return .success(userData)
        } catch {
            return .failure(error)
        }
    }
    
    func searchNeighbourhoodData(for neighbourhood: String) async -> Result<NeighbourhoodModel, Error> {
        do {
            guard let resultAsDictionary = try await db.collection("neighbourhoods")
                .document(neighbourhood)
                .getDocument()
                .data()
            else {
                return .failure(DatabaseError.NeighbourhoodNotFound)
            }
            let resultAsJson = try JSONSerialization.data(withJSONObject: resultAsDictionary)
            let neighbourhoodata = try JSONDecoder().decode(NeighbourhoodModel.self, from: resultAsJson)
            return .success(neighbourhoodata)
        } catch {
            return .failure(error)
        }
    }

    /// Fetches all the posts for the provided neighbourhood.
    /// - Parameter neighbourhood: The neighbourhood where the posts have been posted.
    func searchPosts(
        for neighbourhood: String
    ) async -> Result<[HomePostModel], Error> {
        do {
            let postsAsDocuments = try await db.collection("posts")
                .whereField("neighbourhood", isEqualTo: neighbourhood)
                .order(by: "created_at", descending: true)
                .getDocuments()
            var posts = [HomePostModel]()
            try postsAsDocuments.documents.forEach { postAsDocument in
                let postAsJson = postAsDocument.data()
                let postAsData = try JSONSerialization.data(withJSONObject: postAsJson)
                let post = try JSONDecoder().decode(HomePostModel.self, from: postAsData)
                posts.append(post)
            }
            return .success(posts)
        } catch {
            return .failure(error)
        }
    }

    /// Fetches all the comments for the provided post.
    /// - Parameter post: The post in where to search the comments.
    func searchComments(
        for post: HomePostModel
    ) async -> Result<[HomePostComment], Error> {
        do {
            let commentsAsDocuments = try await db.collection("comments")
                .whereField("post", isEqualTo: post.id)
                .order(by: "created_at", descending: true)
                .getDocuments()
            var comments = [HomePostComment]()
            try commentsAsDocuments.documents.forEach { commentAsDocuments in
                let commentAsJson = commentAsDocuments.data()
                let commentAsData = try JSONSerialization.data(withJSONObject: commentAsJson)
                let comment = try JSONDecoder().decode(HomePostComment.self, from: commentAsData)
                comments.append(comment)
            }
            return .success(comments)
        } catch {
            return .failure(error)
        }
    }

    func searchEvents() async -> Result<[EventModel], Error> {
        do {
            let eventsAsDocuments = try await db.collection("events")
                .order(by: "created_at", descending: true)
                .getDocuments()
            var events = [EventModel]()
            try eventsAsDocuments.documents.forEach { eventAsDocument in
                let eventAsJson = eventAsDocument.data()
                let eventAsData = try JSONSerialization.data(withJSONObject: eventAsJson)
                let event = try JSONDecoder().decode(EventModel.self, from: eventAsData)
                events.append(event)
            }
            return .success(events)
        } catch {
            return .failure(error)
        }
    }

    // MARK: Create
    
    @discardableResult
    func createUser(userData: UserDataModel) async -> Result<UserDataModel, Error> {
        do {
            _ = try await db.collection("users")
                .document(userData.id)
                .setData([
                    "id": userData.id,
                    "email": userData.email,
                    "first_name": userData.firstName,
                    "last_name": userData.lastName ?? ""
                ])
            return .success(userData)
        } catch {
            return .failure(error)
        }
    }
    
    func insertNeighbourhood(
        neighbourhoodId: String,
        neighbourhoodName: String,
        provinceId: String,
        province: String,
        for uid: String
    ) async -> Result<String ,Error> {
        do {
            try await db.collection("users")
                .document(uid)
                .setData(
                    [
                        "neighbourhood": neighbourhoodId,
                        "province_id": provinceId
                    ],
                    merge: true
                )
            
            let neighbourhoodsRef = db.collection("neighbourhoods")
                .document(neighbourhoodId)
            
            try await neighbourhoodsRef
                .setData(
                    [
                        "id": neighbourhoodId,
                        "name": neighbourhoodName,
                        "province_id": provinceId,
                        "province": province
                    ]
                )
            
            try await neighbourhoodsRef
                .updateData(
                    [
                        "population": FieldValue.increment(Int64(1))
                    ]
                )
            
            return .success(neighbourhoodName)
        } catch {
            return .failure(error)
        }
    }

    func insertPost(
        text: String,
        for user: UserDataModel,
        in neighbourhood: String
    ) async throws {
        do {
            let uuid = UUID().uuidString
            try await db.collection("posts")
                .document(uuid)
                .setData(
                    [
                        "id": uuid,
                        "neighbourhood": neighbourhood,
                        "owner": user.id,
                        "text": text,
                        "created_at": Date().timeIntervalSince1970,
                        "liked_by": [],
                        "amount_of_likes": 0,
                        "amount_of_comments": 0,
                        "owner_name": user.lastName != nil ?  "\(user.firstName) \(user.lastName ?? "")" : "\(user.firstName)",
                        "owner_picture_url": user.pictureUrl ?? ""
                    ],
                    merge: true
                )
        } catch {
            throw error
        }
    }

    func insertComment(
        text: String,
        for user: UserDataModel,
        in post: HomePostModel
    ) async throws {
        do {
            let uuid = UUID().uuidString
            try await db.collection("comments")
                .document(uuid)
                .setData(
                    [
                        "id": uuid,
                        "amount_of_likes": 0,
                        "created_at": Date().timeIntervalSince1970,
                        "liked_by": [],
                        "owner": user.id,
                        "owner_name": user.lastName != nil ?  "\(user.firstName) \(user.lastName ?? "")" : "\(user.firstName)",
                        "owner_picture_url": user.pictureUrl ?? "",
                        "text": text,
                        "post": post.id
                    ],
                    merge: true
                )
        } catch {
            throw error
        }
    }

    func insertEvent(
        event: EventModel
    ) async -> Result<EventModel, Error> {
        do {
            try await db.collection("events")
                .document(event.id)
                .setData(
                    [
                        "id": event.id,
                        "title": event.title,
                        "description": event.description,
                        "date": event.date,
                        "assistants": [],
                        "starts_at_hours": event.startsAtHours,
                        "starts_at_minutes": event.startsAtMinutes,
                        "picture_url": event.pictureUrl ?? "",
                        "all_day": event.allDay,
                        "creator": event.creator,
                        "location": event.location,
                        "category": event.category.rawValue
                        
                    ],
                    merge: true
                )
            return .success(event)
        } catch {
            return .failure(error)
        }
    }

    // MARK: Update

    func updateDescription(
        description: String,
        for uid: String
    ) async -> Result<UserDataModel, Error> {
        do {
            let userRef = db.collection("users").document(uid)
            try await userRef.setData(
                [
                    "description": description
                ],
                merge: true
            )
            let resultAsDictionary = try await userRef.getDocument().data()
            let resultAsJson = try JSONSerialization.data(withJSONObject: resultAsDictionary)
            let userData = try JSONDecoder().decode(UserDataModel.self, from: resultAsJson)
            return .success(userData)
        } catch {
            return .failure(error)
        }
    }

    @discardableResult
    func updatePost(
        post: HomePostModel
    ) async -> Result<HomePostModel, Error> {
        do {
            try await db.collection("posts")
                .document(post.id)
                .setData(
                    [
                        "liked_by": post.likedBy,
                        "amount_of_likes": post.amountOfLikes,
                        "amount_of_comments": post.amountOfComments
                    ],
                    merge: true
                )
            return .success(post)
        } catch {
            return .failure(error)
        }
    }

    func updateComment(
        comment: HomePostComment
    ) async -> Result<HomePostComment, Error> {
        do {
            try await db.collection("comments")
                .document(comment.id)
                .setData(
                    [
                        "liked_by": comment.likedBy,
                        "amount_of_likes": comment.amountOfLikes
                    ],
                    merge: true
                )
            return .success(comment)
        } catch {
            return .failure(error)
        }
    }
}
