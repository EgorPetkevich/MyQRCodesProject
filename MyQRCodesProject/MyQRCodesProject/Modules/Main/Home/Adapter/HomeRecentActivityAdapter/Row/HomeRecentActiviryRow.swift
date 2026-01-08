//
//  HomeRecentActiviryRow.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

struct RecentActivityModel {
    var icon: Image
    var bgIconColor: Color
    var title: String
    var subtitle: String
}

struct HomeRecentActiviryRow: View {
    
    private enum Const {
        static let iconSize: CGFloat = 40
        static let cardRadius: CGFloat = 12
        static let rowHeight: CGFloat = 80
    }
    
    var dto: any DTODescription
    var onTap: (() -> Void)?
    
    private var model: RecentActivityModel {
        getRecentActivityModel(dto)
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 16) {
                
                ZStack {
                    Circle()
                        .fill(model.bgIconColor)
                        .frame(width: Const.iconSize, height: Const.iconSize)
                    model.icon
                        .size(12)
                        .foregroundStyle(.appPrimaryBg)
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
    
    private func getRecentActivityModel(_ dto: any DTODescription) -> RecentActivityModel {
        var icon = Image(.myqrcodesQr)
        var bgIconColor: Color = .appAccentPrimary
        let scannedTitle: String = dto.scanned ? "Scanned" : "Created"
        var title: String = ""
    
        switch dto {
            case is LinkDTO:
            title = "\(scannedTitle) website link"
        case is WiFiDTO:
            title = "\(scannedTitle) WiFi QR"
            icon = Image(.homePlus)
            bgIconColor = .appAccentSuccess
        case is ContactDTO:
            title = "\(scannedTitle) contact VCard"
            icon = Image(systemName: "phone")
            bgIconColor = .appAccentSuccess
        case is TextDTO:
            title = "\(scannedTitle) text message"
            icon = Image(systemName: "textformat")
            bgIconColor = .appAccentWarning
        default:
            title = ""
        }
        
        return  RecentActivityModel(icon: icon,
                                    bgIconColor: bgIconColor,
                                    title: title,
                                    subtitle: dto.createdAt.timeAgoString())
        
    }
}
