//
//  HomeHeaderView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 21/09/2024.
//

import SwiftUI

struct HomeHeaderView: View {
    let name: String
    let description: String
    let imageName: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                    .foregroundStyle(.white)
                Text(description)
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            .padding(.trailing, 10)
            .foregroundStyle(Constants.Colors.appColor)
            Spacer()
            Image(imageName)
                .resizable()
                .frame(width: 54, height: 54)
                .clipShape(Circle())
        }
        .padding()
        .padding(.top, 30)
        .padding(.bottom, 30)
        .background(Constants.Colors.appColor)
        .onTapGesture {
            print("abrir perfil")
        }
    }
}

#Preview {
    HomeHeaderView(
        name: "Nicolás Martínez",
        description: "28 años, analista de sistemas y creador de Barrio Conectado.",
        imageName: "person"
    )
}
