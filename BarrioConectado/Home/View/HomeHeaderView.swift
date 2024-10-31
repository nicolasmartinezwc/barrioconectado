//
//  HomeHeaderView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 21/09/2024.
//

import SwiftUI

struct HomeHeaderView: View {
    @ObservedObject var viewModel: HomeViewModel
    let name: String
    let imageName: String
    let description: String
    @Binding var showUpdateDescriptionForm: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                    .foregroundStyle(.white)

                HStack {
                    Text(description.isEmpty ? "Escribe una descripción de tu perfil" : description)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                    Button {
                        showUpdateDescriptionForm = true
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 12, height: 15)
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.trailing, 10)
            .foregroundStyle(Constants.Colors.appColor)
            Spacer()
            Image(imageName)
                .resizable()
                .frame(width: 54, height: 54)
                .clipShape(Circle())
                .onTapGesture {
                    print("abrir perfil")
                }
        }
        .padding()
        .padding(.top, 30)
        .padding(.bottom, 30)
        .background(Constants.Colors.appColor)
    }
}

#Preview {
    HomeHeaderView(
        viewModel: HomeViewModel(),
        name: "Nicolás Martínez",
        imageName: "person",
        description: "28 años, analista de sistemas y creador de Barrio Conectado.",
        showUpdateDescriptionForm: .constant(false)
    )
}
