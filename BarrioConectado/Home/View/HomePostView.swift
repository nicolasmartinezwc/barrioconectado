//
//  HomePostView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 21/09/2024.
//

import SwiftUI

struct HomePostView: View {
    @ObservedObject var viewModel: HomeViewModel
    let post: HomePostModel
    let standalone: Bool
    @State private var showAddCommentForm: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        Text(post.text)
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    HStack {
                        Image(uiImage: viewModel.cachedImagesForPosts[post.id]?.image ?? .init(resource: .avatar))
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        Spacer()
                        let dateComponents = post.createdAt.components
                        if let day = dateComponents.day,
                           let month = dateComponents.month,
                           let year = dateComponents.year {
                            Text("Escrito por \(post.ownerName) el \(day)-\(month)-\(year)")
                                .lineLimit(2)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.init(uiColor: .darkGray))
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        HStack {
                            Text("\(post.amountOfLikes)")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.init(uiColor: .darkGray))
                            Image(systemName: post.liked ? "heart.fill" :"heart")
                                .foregroundStyle(Color.init(uiColor: post.liked ? .red : .darkGray))
                                .onTapGesture {
                                    viewModel.toggleLike(for: post)
                                }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text("\(post.amountOfComments)")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.init(uiColor: .darkGray))
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .foregroundStyle(Color.init(uiColor: .darkGray))
                        }
                    }
                }
                .padding()

                if standalone {
                    if let comments = viewModel.comments[post.id] {
                        VStack {
                            HStack {
                                Text("Comentarios en este post:")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.init(uiColor: .darkGray))
                                    .padding(.horizontal)
                                Spacer()
                            }
                            ForEach(comments) { comment in
                                VStack {
                                    HStack {
                                        Text(comment.text)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.black)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .padding(.bottom, 5)
                                    HStack {
                                        Image(uiImage: viewModel.cachedImagesForComments[comment.id]?.image ?? .init(resource: .avatar))
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .padding(.trailing, 5)
                                        let dateComponents = comment.createdAt.components
                                        if let day = dateComponents.day,
                                           let month = dateComponents.month,
                                           let year = dateComponents.year {
                                            Text("Escrito por \(comment.ownerName) el \(day)-\(month)-\(year)")
                                                .lineLimit(2)
                                                .font(.system(size: 14))
                                                .foregroundStyle(Color.init(uiColor: .darkGray))
                                                .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                        HStack {
                                            Text("\(comment.amountOfLikes)")
                                                .font(.system(size: 14))
                                                .foregroundStyle(Color.init(uiColor: .darkGray))
                                            Image(systemName: comment.liked ? "heart.fill" :"heart")
                                                .foregroundStyle(Color.init(uiColor: comment.liked ? .red : .darkGray))
                                                .onTapGesture {
                                                    viewModel.toggleLike(for: comment)
                                                }
                                        }
                                    }
                                }
                                .padding()
                                .onAppear {
                                    Task { @MainActor in
                                        if viewModel.cachedImagesForComments[comment.id]?.image == nil {
                                            viewModel.fetchImage(for: comment)
                                        }
                                    }
                                }
                                BCDivider()
                            }
                        }
                    } else {
                        HStack {
                            Text("Aún no hay comentarios en este post.")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.init(uiColor: .darkGray))
                                .padding(.horizontal)
                            Spacer()
                        }
                    }

                    HStack {
                        Button {
                            guard standalone else { return }
                            showAddCommentForm = true
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Constants.Colors.appColor)
                                .frame(width: 170, height: 30)
                                .overlay {
                                    Text("Agregar comentario")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                        }
                        .buttonStyle(.plain)
                        .padding()
                        Spacer()
                    }

                    Spacer()
                }
            }
        }
        .onAppear {
            if standalone {
                Task { @MainActor in
                    await viewModel.fetchComments(for: post)
                }
            }

            Task { @MainActor in
                if viewModel.cachedImagesForPosts[post.id]?.image == nil {
                    viewModel.fetchImage(for: post)
                }
            }
        }
        .sheet(isPresented: $showAddCommentForm) {
            BCPopUpTextFieldView(
                title: "Agregar comentario",
                placeholder: "Escribe algo...")
            { newComment in
                InputValidator().validateComment(comment: newComment)
            } onTap: { newComment in
                Task { @MainActor in
                    await viewModel.addComment(text: newComment, for: post)
                    await viewModel.fetchComments(for: post)
                    showAddCommentForm = false
                }
            }
        }
        .background(standalone ? Constants.Colors.backgroundDarkGrayColor : .clear)
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    let model = HomePostModel(
        id: "",
        text: "",
        amountOfLikes: 0,
        amountOfComments: 0,
        likedBy: [],
        owner: "",
        neighbourhood: "",
        createdAt: Date(),
        ownerName: "",
        ownerPictureUrl: ""
    )
    return HomePostView(viewModel: HomeViewModel(), post: model, standalone: false)
}
