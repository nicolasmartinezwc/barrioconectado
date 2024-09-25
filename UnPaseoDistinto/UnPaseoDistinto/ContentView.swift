//
//  ContentView.swift
//  UnPaseoDistinto
//
//  Created by Nicolas Martinez on 22/09/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "pawprint.circle")
                .resizable()
                .imageScale(.large)
                .foregroundStyle(pawColor)
                .frame(width: 80, height: 80)
            Text("Hola, dog lovers!")
                .font(.system(size: 32))
            Image(systemName: "arrow.right")
                .resizable()
                .frame(width: 50, height: 40)
                .padding(.top, 100)
                .onTapGesture {
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
