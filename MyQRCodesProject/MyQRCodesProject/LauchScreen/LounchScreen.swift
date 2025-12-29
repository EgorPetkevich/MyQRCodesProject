//
//  LounchScreen.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

struct LounchScreen: View {
    
    private enum Const {
        static let title: String = "QR Master"
        static let subtitle: String = "Scan • Create • Manage"
        static let loading: String = "Loading..."
        static let version: String = "Version 1.0.0"
    }
    
    var body: some View {
        ZStack {
            Image(.lounchBg)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 40) {
                Spacer()
                
                Image(.lounchQr)
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                
                VStack(spacing: 20) {
                    Text(Const.title)
                        .font(.app(.largeTitle))
                        .foregroundStyle(.appTextPrimary)
                    
                    Text(Const.subtitle)
                        .font(.inter(size: 17, style: .regular))
                        .foregroundStyle(.appTextSecondary)
                }
                
                

                Text(Const.loading)
                    .font(.app(.caption))
                    .foregroundStyle(.appTextSecondary)
                
                Text(Const.version)
                    .font(.inter(size: 13, style: .regular))
                    .foregroundStyle(.appTextDisabled)
                Spacer()
            }
            
            
        }
        
    }
}

#Preview {
    LounchScreen()
}
