//
//  ContentView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 13/09/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @Binding var selectedTab: Int
    @State private var firstAppear: Bool = true
    @State private var showAddPostForm: Bool = false
    @State private var showUpdateDescriptionForm: Bool = false

    var body: some View {
        ZStack{
            VStack {
                VStack {
                    HomeHeaderView(
                        viewModel: viewModel,
                        showUpdateDescriptionForm: $showUpdateDescriptionForm
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
                    Text("Posteos de esta semana en \(viewModel.neighbourhoodModel?.name ?? ""), \(viewModel.neighbourhoodModel?.province ?? "").")
                        .foregroundStyle(.black)
                        .lineLimit(2)
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    HStack {
                        NavigationLink {
                            HomePostsList(viewModel: viewModel, standalone: true)
                        } label: {
                            Text("Ver todos")
                                .foregroundStyle(.black)
                                .lineLimit(1)
                                .font(.system(size: 12))
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 5, height: 8)
                                .foregroundStyle(.black)
                        }
                        .disabled(viewModel.posts.isEmpty)
                    }
                    .padding(.leading, 15)
                }
                .padding(.top, 60)
                .padding(.horizontal)
                
                BCDivider()
                
                HomePostsList(viewModel: viewModel, standalone: false)
                    .padding(.top, -8)
                
            }
            .onAppear {
                if firstAppear {
                    viewModel.fetchUserData(retries: 3)
                } else {
                    viewModel.fetchPosts()
                }
                self.firstAppear = false
            }
            .redacted(reason: viewModel.userModel == nil || viewModel.neighbourhoodModel == nil ? .placeholder : [])
            .fullScreenCover(isPresented: $viewModel.showOnboarding, onDismiss: {
                viewModel.fetchUserData()
            }) {
                OnBoardingView(showOnboarding: $viewModel.showOnboarding)
            }
            .background(.white)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showAddPostForm = true
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Constants.Colors.appColor)
                            .frame(width: 120, height: 30)
                            .overlay {
                                Text("Agregar post")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .padding([.bottom, .trailing])
                    }
                    .buttonStyle(.plain)
                }
            }

            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Spacer()
                    BCSnackBar(text: errorMessage, color: .red)
                        .padding(.bottom)
                }
            }
        }
        .sheet(isPresented: $showAddPostForm) {
            BCPopUpTextFieldView(
                title: "Agregar post",
                placeholder: "Escribe algo..."
            ) { newPost in
                InputValidator().validatePost(post: newPost)
            } onTap: { newPost in
                viewModel.addPost(text: newPost)
                viewModel.fetchPosts()
                showAddPostForm = false
            }
        }
        .sheet(isPresented: $showUpdateDescriptionForm) {            
            BCPopUpTextFieldView(
                title: "Actualizar descripción",
                placeholder: "Escribe algo..."
            ) { newDescription in
                InputValidator().validateUserDescription(description: newDescription)
            } onTap: { newDescription in
                viewModel.updateDescription(description: newDescription)
                showUpdateDescriptionForm = false
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HomeView(selectedTab: .constant(1))
}
