//
//  PaywallDescriptionCard.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 30.12.25.
//

import SwiftUI

protocol PaywallDescriptionCardProtocol {
    var title: String { get }
    var subtitle: String { get }
    var icon: ImageResource { get }
}


struct PaywallDescriptionCard: View {
    
    var card: PaywallDescriptionCardProtocol
    
    var body: some View {
        
        HStack {
            ZStack {
                Circle()
                    .fill(.appAccentPrimary)
                    .frame(width: 48.0, height: 48.0)
                Image(card.icon)
                    .scaledToFit()
                    .padding()
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(card.title)
                    .font(.inter(size: 17, style: .semiBold))
                    .foregroundColor(.appTextPrimary)
                Text(card.subtitle)
                    .font(.inter(size: 15, style: .regular))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.appTextSecondary)
            }
            
            Spacer()
                
        }
        .padding(16.0)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.appPrimaryBg)
                .shadow(
                    color: .black.opacity(0.06),
                    radius: 16,
                    x: 0,
                    y: 4
                )
        )
        .frame(maxWidth: .infinity)
    }
    
}
