//
//  WiFiScanResultVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import SwiftUI

struct WiFiScanResultVC: View {
    
    private enum Const {
        static let title: String = "Scan Result"
        static let actionButtonTitle: String = "Connect Wi-Fi"
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm: WiFiScanResultVM

    init(viewModel: WiFiScanResultVM) {
        self._vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            
            header
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 21) {
                    SuccessfulScanView()
                    resultView
                    
                    VStack(spacing: 13) {
                        ResultActionButton(
                            title: Const.actionButtonTitle,
                            icon: Image(systemName: "wifi"),
                            fillGradient: .appNextButton,
                            didTap: { vm.actionButtonDidTap() }
                        )
                        
                        ResultBottomControls(
                            onCopy: { vm.copyButtonDidTap() },
                            onShare: { vm.shareDidTap() },
                            onSave: { vm.saveButtonDidTap() }
                        )
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 21)
            }
            .background(.appTextBorder)
            
            
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            VStack(spacing: 8) {
                if vm.showCopiedToast {
                    ToastView(text: "Copied", icon: "doc.on.doc")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if vm.showSavedToast {
                    ToastView(text: "Saved", icon: "checkmark")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, 32)
            .animation(.easeInOut(duration: 0.25), value: vm.showCopiedToast)
            .animation(.easeInOut(duration: 0.25), value: vm.showSavedToast)
        }
        .alert(isPresented: $vm.showConnectErrorAlert) {
            Alert(
                title: Text("Wi-Fi Error"),
                message: Text(vm.connectErrorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var header: some View {
        HStack {
            VStack {
                Spacer()
                Text(Const.title)
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
    
    private var resultView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(.resultChain)
                    .size(23)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.appAccentPrimary)
                            .frame(width: 48, height: 48)
                    )
                    .frame(width: 48, height: 48)
                    
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wi-Fi Network")
                        .inter(size: 15, color: .appTextSecondary)
                    
                    Text(vm.wifiDTO.ssid)
                        .inter(size: 17, style: .semiBold)
                }
                
                Spacer()
            }
            
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Full Content")
                        .inter(size: 15, color: .appTextSecondary)

                    infoRow(title: "SSID", value: vm.wifiDTO.ssid)
                    infoRow(title: "Security", value: vm.wifiDTO.security ?? "Open")
                    infoRow(title: "Hidden", value: vm.wifiDTO.isHidden ? "Yes" : "No")

                    if let password = vm.wifiDTO.password {
                        infoRow(title: "Password", value: password)
                    }
                }
                .padding(16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .roundedRectangleAsBackground(
                color: .appTextBorder,
                cornerRadius: 16
            )
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Scanned")
                        .inter(size: 13, color: .appTextSecondary)
                    Text(vm.wifiDTO.createdAt.timeAgoString())
                        .inter(size: 15, style: .medium)
                }
                Spacer()

                VStack(alignment: .leading) {
                    Text("Type")
                        .inter(size: 13, color: .appTextSecondary)
                    Text("Wi-Fi")
                        .inter(size: 15, style: .medium)
                }
            }
            
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .roundedRectangleAsBackground(
            color: .appPrimaryBg,
            cornerRadius: 16
        )
        .setShadow(with: 16)
        .frame(maxWidth: .infinity)
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
