//
//  HomeCarouselView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct HomeCarouselView: View {
    var carousel: [HomeCarouselCellModel]
    @Binding var selectedTab: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(carousel) { model in
                    HomeCarouselCellView(model: model) {
                        selectedTab = model.correspondingTab
                    }
                }
            }
        }
    }
}

#Preview {
    HomeCarouselView(carousel: [], selectedTab: .constant(1))
}
