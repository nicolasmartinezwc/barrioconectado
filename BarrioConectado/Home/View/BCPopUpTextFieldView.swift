//
//  BCPopUpTextFieldView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/10/2024.
//

import Foundation
import SwiftUI

struct BCPopUpTextFieldView: View {
    let title: String
    let placeholder: String
    let validate: (String) -> InputValidator.InputValidatorResult
    let onTap: (String) -> Void
    @State private var textFieldValue: String = ""
    @State private var invalidReason: String = ""

    var body: some View {
        VStack {
            HStack{
                Text(title)
                    .font(.title)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding([.top, .horizontal])

            TextField(placeholder, text: $textFieldValue)
                .frame(height: 80)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.init(uiColor: .lightGray)))
                .padding(.horizontal)

            if !invalidReason.isEmpty {
                HStack {
                    Text(invalidReason)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal)
            }
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Constants.Colors.appColor)
                    .frame(width: 170, height: 30)
                    .overlay {
                        Text("Finalizar")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        switch validate(textFieldValue) {
                        case .valid:
                            onTap(textFieldValue)
                        case .invalid(let reason):
                            invalidReason = reason
                        }
                    }
            }
            .padding(.top)
            .padding(.trailing)
        }
        .presentationDetents([.height(250)])
    }
}
