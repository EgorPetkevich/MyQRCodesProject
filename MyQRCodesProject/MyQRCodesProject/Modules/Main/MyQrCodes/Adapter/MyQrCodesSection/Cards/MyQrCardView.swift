//
//  MyQrCardView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//

import SwiftUI

struct MyQrCardView: View {
    
    let dto: any DTODescription
    let cardDidSelect: () -> Void
    let onShare: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showOptionsMenu = false
    
    private let documentManager = DocumentManager.instance
    
    var body: some View {
        ZStack(alignment: .topTrailing) {

            Button(action: { cardDidSelect(); showOptionsMenu = false }) {
                VStack(spacing: 12) {
                    icon
                    typeContent
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, minHeight: 217.5, alignment: .top)
                .roundedRectangleAsBackground(color: .appPrimaryBg, cornerRadius: 16)
                .setShadow(with: 16)
            }
            .buttonStyle(PlainButtonStyle())
            

            if showOptionsMenu {
                OptionsMenuView(
                    onShare: { onShare(); showOptionsMenu = false } ,
                    onEdit: { onEdit() ; showOptionsMenu = false },
                    onDelete: { onDelete() ; showOptionsMenu = false }
                )
                .offset(x: -12, y: 40)
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
        .background(
            Color.black.opacity(showOptionsMenu ? 0.001 : 0)
                .onTapGesture {
                    showOptionsMenu = false
                }
        )
        
    }
    
    @ViewBuilder
    private var icon: some View {
        if let image = documentManager
            .loadImage(from: .bgImages, with: dto.id) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 96)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.appAccentPrimary)
                    .frame(maxWidth: .infinity, maxHeight: 96)
                Image(.myqrcodesQr)
                    .size(42)
            }
        }
    }
    
    @ViewBuilder
    private var typeContent: some View {
        switch dto {
        case let wifiDTO as WiFiDTO:
            wifiContent(wifiDTO)
        case let contactDTO as ContactDTO:
            contactContent(contactDTO)
        case let textDTO as TextDTO:
            textContent(textDTO)
        case let urlDTO as LinkDTO:
            urlContent(urlDTO)
        default:
            EmptyView()
        }
    }
    
    private func wifiContent(_ dto: WiFiDTO) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("WiFi Info")
                    .inter(size: 15, style: .semiBold)
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        showOptionsMenu.toggle()
                    }
                }){
                    ZStack {
                        Circle()
                            .foregroundStyle(.appPrimarySecondaryBg)
                            .frame(width: 24, height: 24)
                        Image(systemName: "ellipsis")
                            .foregroundColor(.appTextSecondary)
                    }
                    .frame(width: 24, height: 24)
                }
            }
            Text(dto.ssid)
                .inter(size: 13, color: .appTextSecondary)
            
            HStack {
                Text(dto.createdAt.formattedLong)
                    .inter(size: 12, color: .appTextDisabled)
                Spacer()
            }
        }
    }
    
    private func contactContent(_ dto: ContactDTO) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Contact Info")
                    .inter(size: 15, style: .semiBold)
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        showOptionsMenu.toggle()
                    }
                }) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.appPrimarySecondaryBg)
                            .frame(width: 24, height: 24)
                        Image(systemName: "ellipsis")
                            .foregroundColor(.appTextSecondary)
                    }
                    .frame(width: 24, height: 24)
                }
            }
            Text("\((dto.firstName ?? "")) \((dto.lastName ?? "")) vCard")
                .inter(size: 13, color: .appTextSecondary)
            
            HStack {
                Text(dto.createdAt.formattedLong)
                    .inter(size: 12, color: .appTextDisabled)
                Spacer()
            }
        }
    }
    
    private func textContent(_ dto: TextDTO) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Text Message")
                    .inter(size: 15, style: .semiBold)
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        showOptionsMenu.toggle()
                    }
                }) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.appPrimarySecondaryBg)
                            .frame(width: 24, height: 24)
                        Image(systemName: "ellipsis")
                            .foregroundColor(.appTextSecondary)
                    }
                    .frame(width: 24, height: 24)
                }
            }
            Text(dto.text)
                .inter(size: 13, color: .appTextSecondary)
            
            HStack {
                Text(dto.createdAt.formattedLong)
                    .inter(size: 12, color: .appTextDisabled)
                Spacer()
            }
        }
    }
    
    private func urlContent(_ dto: LinkDTO) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("My Website")
                    .inter(size: 15, style: .semiBold)
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        showOptionsMenu.toggle()
                    }
                }) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.appPrimarySecondaryBg)
                            .frame(width: 24, height: 24)
                        Image(systemName: "ellipsis")
                            .foregroundColor(.appTextSecondary)
                    }
                    .frame(width: 24, height: 24)
                   
                }
            }
            Text(dto.link.tecItQRCodeBase ?? dto.link)
                .inter(size: 13, color: .appTextSecondary)
            
            HStack {
                Text(dto.createdAt.formattedLong)
                    .inter(size: 12, color: .appTextDisabled)
                Spacer()
            }
        }
    }
    
}
