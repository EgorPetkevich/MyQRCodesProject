//
//  SortPillView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//

import SwiftUI

struct SortPillView: View {
    
    private enum Const {
        static let height: CGFloat = 38.5
        static let radius: CGFloat = height / 2
    }
    
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .inter(
                    size: 15,
                    style: .medium,
                    color: isSelected ? .appPrimaryBg : .appTextSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .frame(maxWidth: .infinity , maxHeight: Const.height)
               
                .roundedRectangleAsBackground(
                    color: isSelected ? .appAccentPrimary : .appPrimarySecondaryBg,
                    cornerRadius: Const.radius)
//                .overlay(
//                    RoundedRectangle(cornerRadius: Const.radius)
//                        .stroke(
//                            isSelected ? .appAccentPrimary : Color(hex: "#E5E7EB"),
//                            lineWidth: 1
//                        )
//                )
                
        }
    }
    
}

