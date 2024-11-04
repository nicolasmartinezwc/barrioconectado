//
//  CreateAlertView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 03/11/2024.
//

import SwiftUI

struct CreateAlertView: View {
    @ObservedObject var viewModel: AlertsViewModel
    @Binding var showAddAlertForm: Bool
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var selectedCategory: AlertCategory = .emergency
    @State private var confirmTerms: Bool = false
    @State private var isCreatingAlert = false

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack {
                        Text("Crea una alerta")
                            .font(.title)
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .padding()
                }
                .background(Color(UIColor.secondarySystemBackground))
                .padding(.bottom, -10)
                
                Form {
                    Section(header: Text("Descripción")) {
                        VStack {
                            HStack {
                                Text("¿Por qué queres lanzar una alerta?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            TextField("Explica un poco lo que sucedió", text: $description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.vertical, 10)
                    }
                    
                    Section(header: Text("Ubicacion")) {
                        VStack {
                            HStack {
                                Text("¿En donde sucedió exactamente?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            TextField("Ingresa las calles o la dirección", text: $location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.vertical, 10)
                    }
                    
                    Section(header: Text("Categoría")) {
                        Picker("Elige una categoría", selection: $selectedCategory) {
                            ForEach(AlertCategory.allCases, id: \.self) { category in
                                Text("\(category.spanishName)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    
                    Section(header: Text("Confirmación de alerta")) {
                        VStack {
                            HStack {
                                Text("Al enviar una alerta se notificará a los miembros del barrio de la misma. El uso indebido podría implicar el bloqueo de tu cuenta.")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            
                            Toggle("Entiendo las consecuencias y confirmo que quiero enviar la alerta", isOn: $confirmTerms)
                                .padding(.bottom, 10)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    HStack {
                        Text("Enviar alerta")
                            .font(.system(size: 16))
                            .foregroundStyle(confirmTerms ? Constants.Colors.appColor : Color(uiColor: .darkGray))
                        Spacer()
                    }
                    .onTapGesture {
                        guard confirmTerms, !isCreatingAlert else { return }
                        isCreatingAlert = true
                        Task { @MainActor in
                            if case .success = await viewModel.startCreateAlertFlow(
                                description: description,
                                location: location,
                                selectedCategory: selectedCategory
                            ) {
                                viewModel.fetchAlerts()
                                showAddAlertForm = false
                            }
                            isCreatingAlert = false
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
