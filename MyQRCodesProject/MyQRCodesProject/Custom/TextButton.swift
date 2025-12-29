//
//  TextButton.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

struct TextButton: View {
    
    private enum Const {
        static let height: CGFloat = 24
        static let width: CGFloat = 120
        static let cornerRadius: CGFloat = 14
    }
    
    var title: String
    var didTap: (() -> Void)?
    
    var body: some View {
        Button(action: { didTap?() }) {
            Text(title)
                .font(.inter(size: 15, style: .medium))
                .foregroundStyle(.appTextSecondary)
                .frame(maxWidth: .infinity, minHeight: Const.height)
                .background(
                    Rectangle()
                        .fill(.clear)
                )
        }
    }
    
}
