//
//  LinkScanResultVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import SwiftUI

struct LinkScanResultVC: View {
    
    private enum Const {
        static let title: String = "Scan Result"
        static let actionButtonTitle: String = "Open Link"
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(TabBarState.self) private var tabBarState
    
    @StateObject private var vm: LinkScanResultVM

    
    init(viewModel: LinkScanResultVM) {
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
                            icon: Image(.resultLink),
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
                .padding(.top, 21)
                .padding(.bottom, tabBarState.bottomSafeAreaInset)
            }
            .background(.appTextBorder)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            vm.onAppear()
        }
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
            .padding(.bottom, tabBarState.bottomSafeAreaInset + 32)
            .animation(.easeInOut(duration: 0.25), value: vm.showCopiedToast)
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
                    Text("Website URL")
                        .inter(size: 15, color: .appTextSecondary)
                    Text(vm.linkDTO.link)
                        .inter(size: 17, style: .semiBold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Full Content")
                        .inter(size: 15, color: .appTextSecondary)
                    Text(vm.linkDTO.link)
                        .inter(size: 17)
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
                    Text(vm.linkDTO.createdAt.timeAgoString())
                        .inter(size: 15, style: .medium)
                }
                Spacer()

                VStack(alignment: .leading) {
                    Text("Type")
                        .inter(size: 13, color: .appTextSecondary)
                    Text("URL")
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
    
    
}
