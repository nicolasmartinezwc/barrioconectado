//
//  OnBoardingView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 06/10/2024.
//

import SwiftUI

struct OnBoardingView: View {
    @StateObject private var viewModel: OnBoardingViewModel = OnBoardingViewModel()
    @Binding var showOnboarding: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if viewModel.currentStep > 0 {
                        HStack {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 10, height: 18)
                                .padding(.leading, 10)
                                .padding(.top)
                            Spacer()
                        }
                        .onTapGesture {
                            viewModel.goBack()
                        }
                    }

                    Image(viewModel.model.imageName)
                        .resizable()
                        .frame(
                            width: viewModel.model.imageSize.width,
                            height: viewModel.model.imageSize.height
                        )
                        .padding(.bottom, 20)
                        .padding(.top, 50)

                    Text(viewModel.model.text)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24))
                        .padding()

                    if viewModel.isLastStep {
                        NavigationLink {
                            ChooseNeighbourhoodView(showOnboarding: $showOnboarding)
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.link)
                                .frame(
                                    width: viewModel.model.imageSize.width,
                                    height: 50
                                )
                                .overlay {
                                    Text("Comenzar")
                                        .font(.system(size: 18))
                                        .foregroundStyle(.white)
                                }
                        }
                        .padding()
                        .buttonStyle(.plain)
                    } else {
                        Button {
                            viewModel.goNext()
                        } label: {
                            Text("Siguiente")
                                .font(.system(size: 18))
                                .foregroundStyle(.link)
                        }
                        .padding()
                        .buttonStyle(.plain)
                    }
                }
                .animation(
                    .smooth(duration: 0.2),
                    value: viewModel.model
                )
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    OnBoardingView(showOnboarding: .constant(false))
}
