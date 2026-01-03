//
//  HomeRecentActiviryRow.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

struct RecentActivityModel: Hashable {
    var icon: ImageResource
    var bgIconColor: ColorResource
    var title: String
    var subtitle: String
}

struct HomeRecentActiviryRow: View {
    
    private enum Const {
        static let iconSize: CGFloat = 40
        static let cardRadius: CGFloat = 12
        static let rowHeight: CGFloat = 80
    }
    
    var model: RecentActivityModel
    var onTap: (() -> Void)?
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 16) {
                
                ZStack {
                    Circle()
                        .fill(Color(model.bgIconColor))
                        .frame(width: Const.iconSize, height: Const.iconSize)
                    Image(model.icon)
                        .size(12)
                }
                
                VStack(alignment: .leading) {
                    Text(model.title)
                        .inter(size: 17, style: .semiBold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        
                    Text(model.subtitle)
                        .inter(size: 13, color: .appTextSecondary)
                }
                
                Spacer()
                
                Image(.homeArrowRight)
                    .size(12)
                
            }
            .padding(.vertical, 20)
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
