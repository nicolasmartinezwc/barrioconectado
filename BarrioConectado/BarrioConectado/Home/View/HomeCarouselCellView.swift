//
//  HomeCarouselCellView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct HomeCarouselCellView: View {
    let model: HomeCarouselCellModel
    let onTap: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .frame(width: 250, height: 125)
            .padding()
            .shadow(color: .black.opacity(0.10),radius: 5)
            .overlay {
                VStack {
                    HStack {
                        Image(systemName: model.iconName)
                            .foregroundStyle(model.iconColor)
                            .frame(width: 40, height: 40)
                            .background(model.iconBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Spacer()
                    }
                    .padding(.leading, 40)

                    HStack {
                        Text(model.text)
                            .lineLimit(3)
                            .foregroundStyle(.black)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.top, 5)
                        Spacer()
                    }
                    .padding(.leading, 40)
                    .padding(.trailing, 30)
                    
                    Spacer()
                }
            }
            .onTapGesture {
                onTap()
            }
    }
}

#Preview {
    HomeCarouselCellView(
        model:
            HomeCarouselCellModel(
                iconName: "pencil",
                iconColor: .black,
                iconBackgroundColor: .gray,
                text: "Some section",
                correspondingTab: 0),
                onTap: {}
    )
}
