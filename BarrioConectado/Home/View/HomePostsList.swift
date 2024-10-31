//
//  HomePostsList.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct HomePostsList: View {
    @ObservedObject var viewModel: HomeViewModel
    let standalone: Bool

    var body: some View {
        ScrollView {
            if viewModel.posts.isEmpty {
                ContentUnavailableView(
                    "Parece que no hubo posts esta semana...",
                    systemImage: "face.smiling.inverse",
                    description: Text("Se el primero en publicar algo!")
                        .font(.system(size: 18))
                )
                .padding(.top, 50)
            } else {
                ForEach(viewModel.posts.filter { post in
                    guard !standalone else { return true }
                    let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())?.timeIntervalSince1970 ?? 0
                    return post.createdAt.timeIntervalSince1970 >= oneWeekAgo
                }) { post in
                    VStack {
                        NavigationLink {
                            HomePostView(viewModel: viewModel, post: post, standalone: true)
                        } label: {
                            HomePostView(viewModel: viewModel, post: post, standalone: false)
                        }
                        BCDivider()
                    }
                }
            }
        }
        .background(standalone ? Constants.Colors.backgroundDarkGrayColor : .clear)
        .navigationTitle(standalone ? "Posteos en \(viewModel.neighbourhoodModel?.name ?? "")" : "")
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    HomePostsList(viewModel: HomeViewModel(), standalone: false)
}
