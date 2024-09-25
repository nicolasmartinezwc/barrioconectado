//
//  HomeCarouselCellModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct HomeCarouselCellModel: Identifiable {
    let id: UUID = UUID()
    let iconName: String
    let iconColor: Color
    let iconBackgroundColor: Color
    let text: String
    let correspondingTab: Int
}
