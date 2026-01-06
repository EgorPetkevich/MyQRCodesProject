//
//  CreatedQrPreviewVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

struct CreatedQrPreviewVC<DTO: DTODescription>: View {
    
//    private enum Const {
//        static let title: String = "Create QR Code"
//    }
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm: CreatedQrPreviewVM<DTO>

    init(viewModel: CreatedQrPreviewVM<DTO>) {
        self._vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            
            header
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 27) {
                    TheQrCodeIsReadyView()
                    
                    
                    VStack(spacing: 37) {
                        resultView
                        QrCodePrevBottomControls(
                            onShare: { vm.shareDidTap() },
                            onSave: { vm.saveDidTap() }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 25)
            }
            .background(.appTextBorder)
            
            
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            VStack(spacing: 8) {

                if vm.showSavedToast {
                    ToastView(text: "Saved", icon: "checkmark")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, 32)
            .animation(.easeInOut(duration: 0.25), value: vm.showSavedToast)
        }
        .sheet(isPresented: $vm.showShareSheet) {
            if !vm.shareItems.isEmpty {
                ActivityView(activityItems: vm.shareItems)
            }
        }

    }
    
    private var header: some View {
        HStack {
            VStack {
                Spacer()
                Text("Create QR Code")
                    .inter(size: 22, style: .semiBold)
                    .padding(.bottom, 16)
            }
            
            Spacer()
            
            VStack {
                Spacer()
                Button(action: { dismiss() }) {
                    ZStack {
                        Circle()
                            .fill(.appTextBorder)
                            .frame(width: 40, height: 40)
                        Image(.resultCross)
                            .size(9)
                    }
                }
                .padding(.bottom, 16)
                
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 100)
        .background(Color.appPrimaryBg)
    }
    
    @ViewBuilder
    private var resultView: some View {
        let size = UIScreen.main.bounds.width - 96
        
        if let image = vm.qrImage {
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: size, height: size)
                .cornerRadius(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.gray.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.blue, lineWidth: 2)
                )
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: size, height: size)
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.blue)
                    .scaleEffect(1.5)
            }
        }
    }
    
    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(title):")
                .inter(size: 17, style: .semiBold)
            Text(value)
                .inter(size: 17)
                .multilineTextAlignment(.leading)
        }
    }
    
}

