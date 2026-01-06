//
//  ContentTypeCard.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

struct ContentTypeCard: View {

    let type: QRContentType
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            
            textView(with: type)
            
            .frame(maxWidth: .infinity , minHeight: type == .wifi ? 49 : 71)
            .background(isSelected ? Color.appPrimaryBg : .appPrimarySecondaryBg)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color(hex: "#E5E7EB") : Color.appTextBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
    
    @ViewBuilder
    private func textView(with type: QRContentType) -> some View {
        if type == .url || type == .wifi {
            HStack(spacing: 8) {
                Image(type.icon)
                Text(type.title)
                    .inter(
                        size: 15,
                        style: isSelected ? .semiBold : .medium,
                        color: isSelected ? .appTextPrimary : .appTextSecondary
                    )
            }
        } else {
            VStack(spacing: 3) {
                Image(type.icon)
                Text(type.title)
                    .inter(
                        size: 15,
                        style: isSelected ? .semiBold : .medium,
                        color: isSelected ? .appTextPrimary : .appTextSecondary
                    )
            }
        }
    }
}
