//
//  StartView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(systemName: "building.2")
                    .resizable()
                    .frame(width: 250, height: 200)
                Spacer()
                Text("Bienvenido a Barrio Conectado")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding(.horizontal)
                Spacer()

                VStack {
                    Text("Tenes una cuenta?")
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Inicia sesion")
                    }
                    
                    .padding(.bottom, 20)
                    
                    Text("O si no")
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Crea una cuenta")
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    StartView()
}
