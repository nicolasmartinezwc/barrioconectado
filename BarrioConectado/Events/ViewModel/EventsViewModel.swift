//
//  EventsViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/10/2024.
//

import Foundation

class EventsViewModel: ObservableObject {
    private let inputValidator = InputValidator()
    @Published var errorMessage: String?
    @Published var events: [EventModel] = []
    
    init() {
        Task { [weak self] in
            await self?.fetchEvents()
        }
    }

    @MainActor
    func startCreateEventFlow(
        title: String,
        description: String,
        category: EventCategory,
        location: String,
        startsAtHours: Int,
        startsAtMinutes: Int,
        allDay: Bool,
        day: Int,
        month: Int,
        year: Int
    ) async -> Result<EventModel, Error> {
        let validationResult = inputValidator
            .validateEventData(
                title: title,
                description: description,
                location: location,
                day: day,
                month: month,
                year: year
            )
        switch validationResult {
        case .valid:
            return await self.createEvent(
                title: title,
                description: description,
                category: category,
                location: location,
                startsAtHours: startsAtHours,
                startsAtMinutes: startsAtMinutes,
                allDay: allDay,
                day: day,
                month: month,
                year: year,
                pictureUrl: nil
            )
        case .invalid(let reason):
            showErrorMessage(reason)
            return .failure(DatabaseError.ErrorWhileRegisteringEvent)
        }
    }

    @MainActor
    func fetchEvents() {
        Task { [weak self] in
            guard let self else { return }
            let result = await DatabaseManager.instance.searchEvents()
            switch result {
            case .success(let events):
                guard !events.isEmpty else { return }
                self.events = events
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
        }
    }

    @MainActor
    private func createEvent(
        title: String,
        description: String,
        category: EventCategory,
        location: String,
        startsAtHours: Int,
        startsAtMinutes: Int,
        allDay: Bool,
        day: Int,
        month: Int,
        year: Int,
        pictureUrl: String?
    ) async -> Result<EventModel, Error> {
        guard let user = await getUserData()
        else {
            return .failure(DatabaseError.UserNotFound)
        }
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let date = Calendar.current.date(from: dateComponents) ?? Date()
        let event = EventModel(
            id: UUID().uuidString,
            title: title,
            description: description,
            date: date,
            startsAtHours: startsAtHours,
            startsAtMinutes: startsAtMinutes,
            category: category,
            location: location,
            allDay: allDay,
            creator: user.lastName != nil ? "\(user.firstName) \(user.lastName ?? "")" : "\(user.firstName)",
            pictureUrl: pictureUrl,
            assistants: []
        )
        return await DatabaseManager.instance.insertEvent(event: event)
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
