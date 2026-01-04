//
//  SuccessfulScanView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import SwiftUI

struct SuccessfulScanView: View {
    
    private enum Const {
        static let title: String = "Scan Successful"
        static let subtitle: String = "QR code decoded successfully"
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
                Text(Const.subtitle)
                    .inter(size: 15, style: .regular, color: .appTextSecondary)
            }
            
        }
        .frame(height: 148)
    }
    
}
