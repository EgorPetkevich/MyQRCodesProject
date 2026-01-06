//
//  InputField.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

struct InputField: View {

    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .inter(size: 15, style: .medium)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(hex: "#ADAEBC"))
                        .padding(.horizontal, 16)
                }

                TextField("", text: $text)
                    .foregroundColor(Color.appTextPrimary)
                    .padding()
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appTextBorder, lineWidth: 1)
            )
        }
    }
}
