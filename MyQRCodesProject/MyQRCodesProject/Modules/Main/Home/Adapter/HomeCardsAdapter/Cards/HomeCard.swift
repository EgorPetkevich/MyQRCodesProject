//
//  HomeCard.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

protocol HomeCardProtocol {
    var icon: ImageResource { get }
    var bgIconColor: ColorResource { get }
    var title: String { get }
    var subtitle: String { get }
    var height: CGFloat { get }
}

struct HomeCard: View {
    
    private enum Const {
        static let iconSize: CGFloat = 64
        static let cardRadius: CGFloat = 16
    }
    
    var card: HomeCardProtocol
    var onTap: (() -> Void)?
    
    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .center, spacing: 16) {
                
                ZStack {
                    Circle()
                        .fill(Color(card.bgIconColor))
                        .frame(width: Const.iconSize, height: Const.iconSize)
                    Image(card.icon)
                        .size(24)
                }
                
                VStack(alignment: .center, spacing: 6.5) {
                    Text(card.title)
                        .inter(size: 17, style: .semiBold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        
                    Text(card.subtitle)
                        .inter(size: 13, color: .appTextSecondary)
                }
            }
            .padding(.vertical, 24)
            .frame(height: card.height)
            .frame(maxWidth: .infinity)
            .roundedRectangleAsBackground(
                color: .appPrimaryBg,
                cornerRadius: Const.cardRadius
            )
            .setShadow(with: Const.cardRadius)
        }
    }
}
