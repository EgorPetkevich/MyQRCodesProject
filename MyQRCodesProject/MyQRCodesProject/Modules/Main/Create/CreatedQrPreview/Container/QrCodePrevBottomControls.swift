//
//  QrCodePrevBottomControls.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

struct QrCodePrevBottomControls: View {

    let onShare: () -> Void
    let onSave: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            control(icon: .resultShare, title: "Share", action: onShare)
            control(icon: .resultSave, title: "Save", action: onSave)
        }
        .frame(maxWidth: .infinity)
    }

    private func control(
        icon: ImageResource,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 13) {
                Image(icon)
                    .size(17)
                
                Text(title)
                    .inter(size: 13, style: .medium)
                    .foregroundStyle(.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .roundedRectangleAsBackground(
            color: .appPrimaryBg,
            cornerRadius: 12
        )
        .setShadow(with: 12)
       
    }
}
