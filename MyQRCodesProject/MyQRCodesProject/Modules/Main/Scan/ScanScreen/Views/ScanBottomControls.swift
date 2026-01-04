//
//  ScanBottomControls.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

struct ScanBottomControls: View {

    let onFlash: () -> Void
    let onSwitch: () -> Void
    let onGallery: () -> Void

    var body: some View {
        HStack(spacing: 40) {
            control(icon: .scanFlash, title: "Flash", action: onFlash)
            control(icon: .scanCamera, title: "Switch", action: onSwitch)
            control(icon: .scanPhoto, title: "Gallery", action: onGallery)
        }
        .padding(.vertical, 16)
        .frame(height: 107)
        .frame(maxWidth: .infinity)
        .roundedRectangleAsBackground(color: .appPrimaryBg, cornerRadius: 16)
    }

    private func control(
        icon: ImageResource,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.appTextBorder)
                        .frame(width: 48, height: 48)
                    Image(icon)
                        .size(18)
                }
                
                Text(title)
                    .inter(size: 13, style: .medium)
                    .foregroundStyle(.appTextSecondary)
            }
        }
    }
}
