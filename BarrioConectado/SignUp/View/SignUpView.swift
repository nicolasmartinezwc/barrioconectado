//
//  SignUpView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var viewModel: SignUpViewModel = SignUpViewModel()
    @State private var showPassword: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Nombre")
                            TextField("", text: $firstName)
                                .keyboardType(.alphabet)
                                .scrollDismissesKeyboard(.automatic)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 20, trailing: 0))
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Apellido")
                                Text("(Opcional)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 0)
                                Spacer()
                            }
                            TextField("", text: $lastName)
                                .keyboardType(.alphabet)
                                .scrollDismissesKeyboard(.automatic)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading) {
                            Text("Email")
                            TextField("", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .scrollDismissesKeyboard(.automatic)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.bottom)
                        
                        VStack {
                            HStack {
                                Text("Contraseña")
                                Spacer()
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    if showPassword {
                                        Text("Ocultar")
                                            .foregroundStyle(.link)
                                    } else {
                                        Text("Mostrar")
                                            .foregroundStyle(.link)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            if showPassword {
                                TextField("", text: $password)
                                    .keyboardType(.alphabet)
                                    .scrollDismissesKeyboard(.automatic)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                SecureField("", text: $password)
                                    .keyboardType(.alphabet)
                                    .scrollDismissesKeyboard(.automatic)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                    .font(.system(size: 14, weight: .light))
                    .padding([.bottom, .horizontal])
                    
                    Button {
                        viewModel.createUser(
                            email: email,
                            password: password,
                            firstName: firstName,
                            lastName: lastName
                        )
                    } label: {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(.link)
                            .border(.link.opacity(0.2))
                            .frame(height: 44)
                            .overlay {
                                Text("Finalizar")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.white)
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20))
                    }
                    .buttonStyle(.plain)
                }
                .disabled(viewModel.isSignUpRunning)
                .background(.white)
                .padding()
                .clipped()
                .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
            }
            .scrollBounceBehavior(.basedOnSize)
            .background(Constants.Colors.backgroundGrayColor)
            .navigationTitle("Registrarse")
            .navigationBarTitleDisplayMode(.large)
            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Spacer()
                    BCSnackBar(
                        text: errorMessage,
                        color: .red
                    )
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
