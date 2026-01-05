//
//  ResultActionButton.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import SwiftUI

struct ResultActionButton: View {
    
    private enum Const {
        static let height: CGFloat = 60
        static let cornerRadius: CGFloat = 18
    }
    
    var title: String
    var icon: Image
    var fillGradient: LinearGradient = LinearGradient.appNextButton
    var didTap: (() -> Void)?
    
    var body: some View {
        Button(action: { didTap?() }) {
            HStack(spacing: 13) {
                icon
                    .size(18)
                    .foregroundStyle(.appPrimaryBg)
                
                Text(title)
                    .inter(size: 17, style: .medium, color: .appPrimaryBg)
                
            }
            .frame(maxWidth: .infinity, minHeight: Const.height)
            .background(
                RoundedRectangle(cornerRadius: Const.cornerRadius)
                    .fill(fillGradient)
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
