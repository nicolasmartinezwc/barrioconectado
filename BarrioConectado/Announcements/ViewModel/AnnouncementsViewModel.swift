//
//  AnnouncementsViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 01/11/2024.
//

import Foundation

class AnnouncementsViewModel: ObservableObject {
    private let inputValidator = InputValidator()
    @Published var announcements: [AnnouncementModel] = []
    @Published var errorMessage: String?
    @Published var isLoadingAnnouncements: Bool = false

    init() {
        Task { [weak self] in
            await self?.fetchAnnouncements()
        }
    }

    @MainActor
    func fetchAnnouncements() {
        isLoadingAnnouncements = true
        Task { [weak self] in
            guard let self,
                  let user = await getUserData(),
                  let neighbourhood = user.neighbourhood
            else {
                self?.isLoadingAnnouncements = false
                return
            }
            let result = await DatabaseManager.instance.searchAnnouncements(for: neighbourhood)
            switch result {
            case .success(let announcements):
                guard !announcements.isEmpty else { return }
                self.announcements = announcements
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
            isLoadingAnnouncements = false
        }
    }

    @MainActor
    func startCreateAnnouncementFlow(
        title: String,
        description: String,
        selectedCategory: AnnouncementCategory,
        phoneNumber: String,
        usePhoneNumber: Bool
    ) async -> Result<AnnouncementModel ,Error> {
        let validationResult = inputValidator
            .validateAnnouncementData(
                title: title,
                description: description,
                phoneNumber: phoneNumber,
                usePhoneNumber: usePhoneNumber
            )
        switch validationResult {
        case .valid:
            return await self.createAnnouncement(
                title: title,
                description: description,
                selectedCategory: selectedCategory,
                phoneNumber: phoneNumber,
                usePhoneNumber: usePhoneNumber
            )
        case .invalid(let reason):
            showErrorMessage(reason)
            return .failure(DatabaseError.ErrorWhileRegisteringAnnouncement)
        }
    }

    @MainActor
    func createAnnouncement(
        title: String,
        description: String,
        selectedCategory: AnnouncementCategory,
        phoneNumber: String,
        usePhoneNumber: Bool
    ) async -> Result<AnnouncementModel, Error> {
        guard let user = await getUserData()
        else {
            return .failure(DatabaseError.UserNotFound)
        }

        guard let neighbourhood = user.neighbourhood
        else {
            return .failure(DatabaseError.NeighbourhoodNotFound)
        }

        let announcement = AnnouncementModel(
            id: UUID().uuidString,
            title: title,
            description: description,
            category: selectedCategory,
            owner: user.id,
            ownerName: user.lastName != nil ? "\(user.firstName) \(user.lastName ?? "")" : "\(user.firstName)",
            ownerEmail: user.email,
            createdAt: Date(),
            contactPhone: usePhoneNumber ? phoneNumber : nil,
            neighbourhood: neighbourhood
        )
        return await DatabaseManager.instance.insertAnnouncement(announcement: announcement)
    }

    @MainActor
    func removeAnnouncement(
        announcement: AnnouncementModel
    ) {
        announcements.removeAll { $0 == announcement }
        Task {
            DatabaseManager.instance.removeAnnouncement(announcement: announcement)
        }
    }

    private func getUserData() async -> UserDataModel? {
        guard let uid = AuthManager.instance.currentUserUID else { return nil }
        let result = await DatabaseManager.instance.searchUserData(for: uid)
        switch result {
        case .success(let userData):
            return userData
        case .failure(_):
            return nil
        }
    }

    func showErrorMessage(_ message: String) {
        errorMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.errorMessage = nil
        }
    }
}
