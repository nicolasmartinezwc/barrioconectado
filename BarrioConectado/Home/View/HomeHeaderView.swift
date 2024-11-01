//
//  HomeHeaderView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 21/09/2024.
//

import SwiftUI
import PhotosUI

struct HomeHeaderView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var showUpdateDescriptionForm: Bool
    @State private var showOptionsSheet: Bool = false
    @State private var selectedImage: PhotosPickerItem? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Hola,")
                        .lineLimit(1)
                        .font(.title)
                        .foregroundStyle(.white)
                    Text("\(viewModel.userModel?.firstName ?? "") \(viewModel.userModel?.lastName ?? "")")
                        .lineLimit(2)
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding(.trailing, 10)
                }
                Spacer()
                
                Button {
                    showOptionsSheet = true
                } label: {
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                        .overlay {
                            if viewModel.isLoadingImage {
                                ZStack {
                                    Circle()
                                        .fill(.black.opacity(0.8))
                                        .frame(width: 65, height: 65)
                                    ProgressView()
                                        .tint(.white)
                                }
                            }
                            
                        }
                }
                .buttonStyle(.plain)
            }
            .frame(height: 80)
            
            HStack {
                Text((viewModel.userModel?.description.isEmpty ?? true ? "Escribe una descripción de tu perfil" : viewModel.userModel?.description ?? ""))
                    .lineLimit(2)
                    .font(.system(size: 16))
                    .foregroundStyle(Constants.Colors.backgroundDarkGrayColor)
                    .padding(.trailing, 10)
                
                Button {
                    showUpdateDescriptionForm = true
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black.opacity(0.2))
                        .frame(width: 80, height: 25)
                        .overlay {
                            Text("Editar")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        }
                }
                .buttonStyle(.plain)
            }
            .frame(height: 44)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 50)
        .background(Constants.Colors.appColor)
        .sheet(isPresented: $showOptionsSheet) {
            VStack {
                PhotosPicker(
                    selection: $selectedImage,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Constants.Colors.backgroundGrayColor)
                        .frame(height: 44)
                        .overlay {
                            Text("Cambiar foto de perfil")
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                        }
                }
                .buttonStyle(.plain)
                .padding(.bottom, 10)
                .onChange(of: selectedImage) {
                    showOptionsSheet = false
                    viewModel.uploadImage(newImage: selectedImage)
                }
                HStack {
                    Text("Debe estar en formato .JPEG o .PNG y pesar menos de 10 MB.")
                        .font(.system(size: 12))
                        .foregroundStyle(.red)
                    Spacer()
                }

                Button {
                    AuthManager.instance.logOut()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Constants.Colors.darkDanger)
                        .frame(height: 44)
                        .overlay {
                            Text("Cerrar sesión")
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                        }
                }
                .buttonStyle(.plain)
                .padding(.top, 30)
            }
            .padding()
            .presentationDetents([.height(220)])
        }
    }
}

#Preview {
    HomeHeaderView(
        viewModel: HomeViewModel(),
        showUpdateDescriptionForm: .constant(false)
    )
}
