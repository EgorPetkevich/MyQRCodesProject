//
//  HistoryRow.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import SwiftUI

struct HistoryRow: View {
    
    let dto: any DTODescription
    let cardDidSelect: () -> Void
    let onCopie: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            typeContent
        }
        .frame(maxWidth: .infinity, minHeight: 103, alignment: .top)
        .roundedRectangleAsBackground(color: .appPrimaryBg, cornerRadius: 16)
        .setShadow(with: 16)
        .contentShape(Rectangle()) 
        .onTapGesture {
            cardDidSelect()
        }
    }
    
    @ViewBuilder
    private var typeContent: some View {
        switch dto {
        case let wifiDTO as WiFiDTO:
            historyRow(
                icon: Image(.homePlus),
                fillIcon: .appAccentSuccess,
                title: "WiFi Network",
                subtitle: wifiDTO.ssid,
                createdAt: wifiDTO.createdAt,
                scanned: wifiDTO.scanned
            )
        case let contactDTO as ContactDTO:
            historyRow(
                icon: Image(systemName: "phone"),
                fillIcon: .appAccentSuccess,
                title: "Contact vCard",
                subtitle: "\(contactDTO.firstName ?? "") \(contactDTO.lastName ?? "")",
                createdAt: contactDTO.createdAt,
                scanned: contactDTO.scanned
            )
        case let textDTO as TextDTO:
            historyRow(
                icon: Image(systemName: "textformat"),
                fillIcon: .appAccentWarning,
                title: "Text Message",
                subtitle: textDTO.text,
                createdAt: textDTO.createdAt,
                scanned: textDTO.scanned
            )
        case let urlDTO as LinkDTO:
            historyRow(
                icon: Image(.myqrcodesQr),
                fillIcon: .appAccentPrimary,
                title: "Website Link",
                subtitle: urlDTO.link,
                createdAt: urlDTO.createdAt,
                scanned: urlDTO.scanned
            )
        default:
            EmptyView()
        }
    }
    
    private func historyRow(
        icon: Image,
        fillIcon: Color,
        title: String,
        subtitle: String,
        createdAt: Date,
        scanned: Bool
    ) -> some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(fillIcon)
                    .frame(width: 48, height: 48)
                icon
                    .size(15)
                    .foregroundStyle(.appPrimaryBg)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .inter(size: 17, style: .medium)
                Text(subtitle)
                    .inter(size: 15, color: .appTextSecondary)
                Text("\(scanned ? "Scanned" : "Created") • \(createdAt.formattedTime)")
                    .inter(size: 13, color: .appTextDisabled)
            }
            
            Spacer()
            
            Button(action: onCopie) {
                ZStack {
                    Circle()
                        .foregroundStyle(.appPrimarySecondaryBg)
                        .frame(width: 32, height: 32)
                    Image(.historyCopy)
                        .size(12)
                        .foregroundColor(.appTextSecondary)
                }
                .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            
            Button(action: onShare) {
                ZStack {
                    Circle()
                        .foregroundStyle(.appPrimarySecondaryBg)
                        .frame(width: 32, height: 32)
                    Image(.historyShare)
                        .size(12)
                        .foregroundColor(.appTextSecondary)
                }
                .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}
