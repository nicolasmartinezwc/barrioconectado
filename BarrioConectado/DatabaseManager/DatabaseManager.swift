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
        province: String,
        for uid: String
    ) async -> Result<String ,Error> {
        do {
            try await db.collection("users")
                .document(uid)
                .setData(
                    [
                        "neighbourhood": neighbourhoodId,
                        "province": province
                    ],
                    merge: true
                )

            let neighbourhoodsRef = db.collection("neighbourhoods")
                .document(neighbourhoodId)

            try await neighbourhoodsRef
                .setData(
                    [
                        "name": neighbourhoodName,
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
        post: String,
        for uid: String,
        in neighbourhood: String
    ) async throws {
        do {
            try await db.collection("posts")
                .document()
                .setData(
                    [
                        "neighbourhood": neighbourhood,
                        "owner": uid,
                        "post": post
                    ],
                    merge: true
                )
        } catch {
            throw error
        }
    }
}
