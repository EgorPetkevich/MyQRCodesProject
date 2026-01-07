//
//  OptionsMenuView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//

import SwiftUI

struct CircleButton: View {
    let title: String
    let icon: ImageResource
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 34, height: 34)
                Image(icon)
                    .size(12)
                    .foregroundColor(.white)
            }

            Text(title)
                .inter(size: 9, color: .appTextSecondary)
        }
        
    }
}
struct OptionsMenuView: View {
    var onShare: () -> Void
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CircleButton(title: "Share All", icon: .myqrcodesShare, color: .appAccentPrimary)
                .onTapGesture(perform: onShare)

//            CircleButton(title: "Edit", icon: .myqrcodesEdit, color: .appAccentPrimary)
//                .onTapGesture(perform: onEdit)

            CircleButton(title: "Delete", icon: .myqrcodesTrash, color: .appAccentWarning)
                .onTapGesture(perform: onDelete)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 12)
        )
    }
}
