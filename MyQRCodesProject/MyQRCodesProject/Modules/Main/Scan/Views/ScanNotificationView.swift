//
//  ScanNotificationView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

struct ScanNotificationView: View {
    
    private enum Const {
        static let title: String = "Align QR code within frame"
        static let subtitle: String = "Keep your device steady"
        static let iconSize: CGFloat = 40
        static let cardRadius: CGFloat = 16
        static let rowHeight: CGFloat = 76
    }
    
    var onTap: (() -> Void)?
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 12) {
                
                ZStack {
                    Circle()
                        .fill(Color(.appAccentPrimary))
                        .frame(width: Const.iconSize, height: Const.iconSize)
                    Image(.scanNoti)
                        .size(13)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(Const.title)
                        .inter(size: 15)
                        
                    Text(Const.subtitle)
                        .inter(size: 13, color: .appTextDisabled)
                }
                
                Spacer()
                
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 16)
            .frame(height: Const.rowHeight)
            .frame(maxWidth: .infinity)
            .roundedRectangleAsBackground(
                color: .appPrimaryBg,
                cornerRadius: Const.cardRadius
            )
            .setShadow(with: Const.cardRadius)
        }
    }
}
