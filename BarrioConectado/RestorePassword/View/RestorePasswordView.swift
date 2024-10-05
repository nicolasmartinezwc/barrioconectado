//
//  RestorePasswordView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 05/10/2024.
//

import SwiftUI

struct RestorePasswordView: View {
    @ObservedObject private var viewModel: RestorePasswordViewModel = RestorePasswordViewModel()
    @State private var email: String = ""

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Ingresa tu dirección de e-mail y te enviaremos un correo para que restablezcas tu contraseña.")
                        .font(.system(size: 16))
                        .padding([.top, .horizontal])
                    
                    TextField("Ingresa tu e-mail", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .scrollDismissesKeyboard(.automatic)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.horizontal, .bottom])
                        .padding(.top, 10)
                    
                    Button {
                        viewModel.restorePassword(for: email)
                    } label: {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(.link)
                            .border(.link.opacity(0.2))
                            .frame(height: 44)
                            .overlay {
                                Text("Restablecer contraseña")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.white)
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20))
                    }
                    .buttonStyle(.plain)
                }
                .disabled(viewModel.isRestoringRunning)
                .background(.white)
                .padding()
                .clipped()
                .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Restablecer contraseña")
            .navigationBarTitleDisplayMode(.large)
            .background(Constants.Colors.backgroundGrayColor)
            
            if let snackBarModel = viewModel.snackBarModel {
                VStack {
                    Spacer()
                    BCSnackBar(text: snackBarModel.text, color: snackBarModel.color)
                }
            }
        }
    }
}

#Preview {
    RestorePasswordView()
}
