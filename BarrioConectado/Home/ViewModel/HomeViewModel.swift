//
//  HomeViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import Foundation

class HomeViewModel: ObservableObject {
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
}
