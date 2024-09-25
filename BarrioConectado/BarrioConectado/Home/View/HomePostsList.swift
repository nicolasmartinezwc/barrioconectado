//
//  HomePostsList.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct HomePostsList: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            if viewModel.posts.isEmpty {
                ContentUnavailableView(
                    "Aún no tenemos publicaciones para mostrar...",
                    systemImage: "face.smiling.inverse",
                    description: Text("Se el primero en publicar algo!")
                        .font(.system(size: 18))
                )
                .padding(.top, 50)
            } else {
                ForEach(viewModel.posts) { post in
                    VStack {
                        HomePostView(post: post)
                            .padding()
                        BCDivider()
                    }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
    }
}

#Preview {
    HomePostsList(viewModel: HomeViewModel())
}
