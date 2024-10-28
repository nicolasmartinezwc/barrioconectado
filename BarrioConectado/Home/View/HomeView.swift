//
//  ContentView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 13/09/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            VStack {
                HomeHeaderView(
                    name: viewModel.userName,
                    description: "lorem ipsum dolor sit amet.",
                    imageName: "person"
                )
                
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 25,
                    bottomTrailingRadius: 25,
                    topTrailingRadius: 0
                )
                .frame(height: 75)
                .padding(.top, -10)
                .foregroundStyle(Constants.Colors.appColor)
                .overlay {
                    HomeCarouselView(carousel: viewModel.carousel, selectedTab: $selectedTab)
                        .padding(.top, 15)
                }
            }
            
            HStack {
                Text("Últimas publicaciones en San Martín")
                    .foregroundStyle(.black)
                    .lineLimit(1)
                    .font(.system(size: 16, weight: .medium))
                
                Spacer()
               
                HStack {
                    Text("Ver todas")
                        .foregroundStyle(.black)
                        .lineLimit(1)
                        .font(.system(size: 12))
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 5, height: 8)
                        .foregroundStyle(.black)
                }
                .padding(.leading, 15)
            }
            .padding(.top, 75)
            .padding(.horizontal)

            BCDivider()
            
            HomePostsList(viewModel: viewModel)
                .padding(.top, -8)

        }
        .onAppear {
            viewModel.fetchUserData()
        }
        .redacted(reason: viewModel.userData == nil ? .placeholder : [])
        .fullScreenCover(isPresented: $viewModel.showOnboarding) {
            OnBoardingView(showOnboarding: $viewModel.showOnboarding)
        }
        .background(.white)
    }
}

#Preview {
    HomeView(selectedTab: .constant(1))
}
