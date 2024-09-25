//
//  HomePostView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 21/09/2024.
//

import SwiftUI

struct HomePostView: View {
    let post: HomePostModel

    var body: some View {
        VStack {
            HStack {
                Text(post.text)
                    .font(.system(size: 16))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.bottom)
            HStack {
                Spacer()
                HStack {
                    Text("\(post.amountOfLikes)")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                    Image(systemName: post.liked ? "heart.fill" :"heart")
                        .foregroundStyle(Color.init(uiColor: post.liked ? .red : .darkGray))
                }
                .padding(.horizontal)

                HStack {
                    Text("\(post.amountOfComments)")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .foregroundStyle(Color.init(uiColor: .darkGray))
                }
            }
        }
    }
}

#Preview {
    let model = HomePostModel(
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ali",
        amountOfLikes: 23,
        amountOfComments: 5,
        liked: true
    )
    return HomePostView(post: model)
}
