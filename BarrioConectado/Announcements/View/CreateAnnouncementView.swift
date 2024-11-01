//
//  CreateAnnouncementView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 01/11/2024.
//

import SwiftUI

struct CreateAnnouncementView: View {
    @ObservedObject var viewModel: AnnouncementsViewModel
    @Binding var showAddAnnouncementForm: Bool
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: AnnouncementCategory = .exchange
    @State private var usePhoneNumber: Bool = false
    @State private var phoneNumber: String = ""
    @State private var isCreatingAnnouncement = false

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack {
                        Text("Crea un anuncio")
                            .font(.title)
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .padding([.top, .horizontal])

                    HStack {
                        Text("En esta seccion podes anunciar un intercambio de artículos, donación o trabajo, ya sea que estes buscando u ofreciendo uno.")
                            .font(.subheadline)
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .padding([.bottom, .horizontal])
                }
                .background(Color(UIColor.secondarySystemBackground))
                .padding(.top, 10)
                .padding(.bottom, -10)
                
                Form {
                    Section(header: Text("Título")) {
                        VStack {
                            HStack {
                                Text("¿Cuál es el anuncio?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            TextField("Ingresa el título del anuncio", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.vertical, 10)
                    }
                    
                    Section(header: Text("Descripción")) {
                        VStack {
                            HStack {
                                Text("¿De qué trata el anuncio?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            TextField("Ingresa una descripción", text: $description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.vertical, 10)
                    }
                    
                    Section(header: Text("Categoría")) {
                        Picker("Elige una categoría", selection: $selectedCategory) {
                            ForEach(AnnouncementCategory.allCases, id: \.self) { category in
                                HStack {
                                    Image(systemName: category.information.iconName)
                                        .foregroundStyle(category.information.iconColor)
                                        .frame(width: 25, height: 25)
                                        .background(category.information.iconBackgroundColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(.leading)
                                    
                                    Text("\(category.information.spanishName)")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    Section(header: Text("Información de contacto")) {
                        VStack {
                            HStack {
                                Text("Se mostrará tu correo y tu nombre por defecto")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .padding(.bottom, 10)

                            Toggle("Agregar número de teléfono", isOn: $usePhoneNumber)
                                .padding(.bottom, 10)
                            
                            TextField("¿Cuál es tu número?", text: $phoneNumber)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(!usePhoneNumber)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    HStack {
                        Text("Finalizar")
                            .font(.system(size: 16))
                            .foregroundStyle(Constants.Colors.appColor)
                        Spacer()
                    }
                    .onTapGesture {
                        guard !isCreatingAnnouncement else { return }
                        isCreatingAnnouncement = true
                        Task { @MainActor in
                            if case .success = await viewModel.startCreateAnnouncementFlow(
                                title: title,
                                description: description,
                                selectedCategory: selectedCategory,
                                phoneNumber: phoneNumber,
                                usePhoneNumber: usePhoneNumber
                            ) {
                                viewModel.fetchAnnouncements()
                                showAddAnnouncementForm = false
                            }
                            isCreatingAnnouncement = false
                        }
                    }
                }
            }

            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Spacer()
                    BCSnackBar(text: errorMessage, color: .red)
                }
            }
        }
    }
}
