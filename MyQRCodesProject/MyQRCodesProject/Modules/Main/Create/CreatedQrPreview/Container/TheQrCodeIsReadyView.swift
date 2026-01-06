//
//  TheQrCodeIsReadyView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

struct TheQrCodeIsReadyView: View {
    
    private enum Const {
        static let title: String = "The QR code is ready"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(.resultCheck)
                .size(25)
                .background(
                    Circle()
                        .fill(.appAccentSuccess)
                        .frame(width: 80, height: 80)
                        .setShadow(with: 24, color: .appAccentSuccess)
                )
                .frame(width: 80, height: 80)
            
            VStack(alignment: .center, spacing: 4) {
                Text(Const.title)
                    .inter(size: 17, style: .semiBold)
            }
            
        }
        .frame(height: 148)
    }
    
}
