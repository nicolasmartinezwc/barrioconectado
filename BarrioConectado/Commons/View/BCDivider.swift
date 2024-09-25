//
//  BCDivider.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct BCDivider: View {
    var body: some View {
        Divider()
         .frame(height: 1)
         .padding(.vertical, 0)
         .background(Color.init(uiColor: .lightGray).opacity(0.1))
    }
}

#Preview {
    BCDivider()
}
