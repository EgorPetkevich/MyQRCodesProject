//
//  ActionButton.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

struct ActionButton: View {
    
    private enum Const {
        static let height: CGFloat = 60
        static let cornerRadius: CGFloat = 18
    }
    
    var title: String
    var didTap: (() -> Void)?
    
    var body: some View {
        Button(action: { didTap?() }) {
            Text(title)
                .font(.inter(size: 17, style: .semiBold))
                .foregroundStyle(.appPrimaryBg)
                .frame(maxWidth: .infinity, minHeight: Const.height)
                .background(
                    RoundedRectangle(cornerRadius: Const.cornerRadius)
                        .fill(LinearGradient.appNextButton)
                        .shadow(
                            color: .black.opacity(0.06),
                            radius: 16,
                            x: 0,
                            y: 4
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Const.cornerRadius)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
        }
    }
}
