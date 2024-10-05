//
//  BCSnackBar.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 05/10/2024.
//

import SwiftUI

struct BCSnackBar: View {
    var text: String
    var color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .frame(height: 50)
            .overlay {
                Text(text)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.horizontal)
    }
}

#Preview {
    BCSnackBar(text: "Error message", color: .red)
}
