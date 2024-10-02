//
//  StartView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct StartView: View {
    @State private var showPassword: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Bienvenido/a a  Barrio Conectado")
                    .font(.title)
                    .padding()
                    .multilineTextAlignment(.center)

                Image(.logo)
                    .resizable()
                    .frame(width: 250, height: 125)
                    .padding([.horizontal, .bottom])

                VStack {
                    Button {
                        AuthManager.instance.logIn()
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.clear)
                            .border(.link, width: 0.2)
                            .frame(height: 44)
                            .padding()
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
                    }
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
                        print("Iniciar sesión")
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
                    .buttonStyle(.plain)

                    NavigationLink {
                        SignUpView()
                    } label: {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(.white)
                            .border(.link.opacity(0.2))
                            .frame(height: 44)
                            .padding()
                            .overlay {
                                Text("Registrarse")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.link)
                            }
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
        }
    }
}

#Preview {
    StartView()
}
