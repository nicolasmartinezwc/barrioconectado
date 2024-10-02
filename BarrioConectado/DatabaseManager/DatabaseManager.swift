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

    func searchUserData(for uid: String?) async -> UserDataModel? {
        guard let uid else { return nil }
        return UserDataModel(id: "test_id", email: "test_email", firstName: "test_name", lastName: "test_last_name")
    }

    func createUserData(with data: UserDataModel) async -> Result<UserDataModel,Error> {
        .success(data)
    }
}
