//
//  HomeViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    // MARK: Properties

    @Published var userData: UserDataModel?
    @Published var errorMessage: String?
    @Published var showOnboarding: Bool = false

    var userName: String {
        guard let userData else { return "" }
        return "\(userData.firstName) \(userData.lastName ?? "")"
    }

    let carousel: [HomeCarouselCellModel] = [
        HomeCarouselCellModel(
            iconName: "fireworks",
            iconColor: Constants.Colors.caramel,
            iconBackgroundColor: Constants.Colors.peach,
            text: "Mira los últimos eventos por tu barrio.",
            correspondingTab: Constants.Tabs.events
        ),
        HomeCarouselCellModel(
            iconName: "exclamationmark.triangle.fill",
            iconColor: Constants.Colors.yellow,
            iconBackgroundColor: Constants.Colors.darkPeach,
            text: "Está al tanto de las emeregencias vecinales.",
            correspondingTab: Constants.Tabs.alerts
        ),
        HomeCarouselCellModel(
            iconName: "storefront",
            iconColor: Constants.Colors.darkNature,
            iconBackgroundColor: Constants.Colors.nature,
            text: "Vende o regala articulos que ya no utilices",
            correspondingTab: Constants.Tabs.exchanges
        )
    ]

    var posts: [HomePostModel] = []

    // MARK: Methods

    func showErrorMessage(_ message: String) {
        errorMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.errorMessage = nil
        }
    }

    /// Fetches user data from the database.
    @MainActor
    func fetchUserData() {
        guard let uid = AuthManager.instance.currentUserUID else {
            let error = AuthenticaitonError.UserIdentifierIsNil
            return showErrorMessage(error.spanishDescription)
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                userData = try await DatabaseManager.instance.searchUserData(for: uid).get()
                showOnboarding = userData?.neighbourhood == nil
            } catch {
                showErrorMessage(error.spanishDescription)
            }
        }
    }

}
