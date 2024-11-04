//
//  AlertsViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 03/11/2024.
//

import Foundation

class AlertsViewModel: ObservableObject {
    let inputValidator = InputValidator()
    @Published var alerts: [AlertModel] = []
    @Published var errorMessage: String?
    @Published var isLoadingAlerts: Bool = false

    init() {
        Task { [weak self] in
            await self?.fetchAlerts()
        }
    }

    @MainActor
    func fetchAlerts() {
        isLoadingAlerts = true
        Task { [weak self] in
            guard let user = await self?.getUserData(),
                  let neighbourhood = user.neighbourhood
            else {
                self?.isLoadingAlerts = false
                return
            }
            let result = await DatabaseManager.instance.searchAlerts(for: neighbourhood)
            switch result {
            case .success(let alerts):
                guard !alerts.isEmpty 
                else {
                    self?.isLoadingAlerts = false
                    return
                }
                self?.alerts = alerts
            case .failure(let error):
                self?.showErrorMessage(error.spanishDescription)
            }
            self?.isLoadingAlerts = false
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

    @MainActor
    func startCreateAlertFlow(
        description: String,
        location: String,
        selectedCategory: AlertCategory
    ) async -> Result<AlertModel ,Error> {
        let validationResult = inputValidator
            .validateAlertData(
                description: description,
                location: location
            )
        switch validationResult {
        case .valid:
            return await self.createAlert(
                description: description,
                location: location,
                selectedCategory: selectedCategory
            )
        case .invalid(let reason):
            showErrorMessage(reason)
            return .failure(DatabaseError.ErrorWhileRegisteringAlert)
        }
    }

    @MainActor
    private func createAlert(
        description: String,
        location: String,
        selectedCategory: AlertCategory
    ) async -> Result<AlertModel, Error> {
        guard let user = await getUserData()
        else {
            return .failure(DatabaseError.UserNotFound)
        }

        guard let neighbourhood = user.neighbourhood
        else {
            return .failure(DatabaseError.NeighbourhoodNotFound)
        }
        
        let alert = AlertModel(
            id: UUID().uuidString,
            location: location,
            neighbourhood: neighbourhood,
            creator: user.id,
            creatorName: user.lastName != nil ? "\(user.firstName) \(user.lastName ?? "")" : "\(user.firstName)",
            description: description,
            createdAt: Date(),
            category: selectedCategory
        )

        return await DatabaseManager.instance.insertAlert(alert: alert)
    }
}
