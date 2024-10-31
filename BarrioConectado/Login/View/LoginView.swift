//
//  LoginView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel = LoginViewModel()
    @State private var showPassword: Bool = false
    @State private var email: String = "test@test.com"
    @State private var password: String = "123456"
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    Text("Bienvenido/a a Barrio Conectado")
                        .font(.title)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Image(.logo)
                        .resizable()
                        .frame(width: 250, height: 125)
                        .padding([.horizontal, .bottom])
                    
                    VStack {
                        Button {
                            viewModel.startLoginWithGoogleFlow()
                        } label: {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.clear)
                                .border(.link, width: 0.2)
                                .frame(height: 44)
                                .overlay {
                                    HStack {
                                        Image(.google)
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("Continuar con Google")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundStyle(.link)
                                    }
                                }
                                .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
                        }
                        .disabled(viewModel.isLoginRunning)
                        .buttonStyle(.plain)
                        
                        HStack {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(.black.opacity(0.1))
                                .padding(.leading)
                            Text("O continua con tu correo")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 14, weight: .light))
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(.black.opacity(0.1))
                                .padding(.trailing)
                        }
                        .padding(.bottom)
                        
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Email")
                                TextField("", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .scrollDismissesKeyboard(.automatic)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading) {
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

                                NavigationLink {
                                    RestorePasswordView()
                                } label: {
                                    HStack {
                                        Text("¿Olvidaste tu contraseña?")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundStyle(.tint)
                                    }
                                }
                                .buttonStyle(.plain)
                                .padding(.top, 3)
                            }
                        }
                        .font(.system(size: 14, weight: .light))
                        .padding([.bottom, .horizontal])
                        
                        Button {
                            viewModel.logInWithCredentials(email: email, password: password)
                        } label: {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.link)
                                .frame(height: 44)
                                .padding([.horizontal])
                                .overlay {
                                    Text("Iniciar sesión")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(.white)
                                }
                        }
                        .disabled(viewModel.isLoginRunning)
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                            SignUpView()
                        } label: {
                            HStack {
                                Text("¿Todavía no tenes una cuenta?")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.tint)
                                Text("Crea una.")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.tint)
                                    .padding(.leading, -3)
                            }
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
                        }
                        .buttonStyle(.plain)
                    }
                    .background(.white)
                    .padding([.horizontal, .bottom])
                    .clipped()
                    .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
                }
                .scrollBounceBehavior(.basedOnSize)
                .background(Constants.Colors.backgroundGrayColor)
                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        BCSnackBar(text: errorMessage, color: .red)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
