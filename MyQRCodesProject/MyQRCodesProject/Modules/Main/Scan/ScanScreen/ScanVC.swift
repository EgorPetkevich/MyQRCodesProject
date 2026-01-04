//
//  ScanVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

struct ScanVC: View {
    
    private enum Const {
        static let title: String = "Scan QR Code"
    }
    
    @Environment(TabBarState.self) private var tabState
    @StateObject private var vm: ScanVM
    
    @State private var showPhotoPicker = false
    @State private var pickedImage: UIImage? = nil
    
    init(viewModel: ScanVM) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ZStack {
                if let previewLayer = vm.previewLayer {
                    CameraPreview(previewLayer: previewLayer)
                }
                
                VStack {
                    Spacer()
                    
                    ScanNotificationView()
                        .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    ScannerFrameView()
                    
                    Spacer()
                    
                    ScanBottomControls(
                        onFlash: { vm.toggleFlash() },
                        onSwitch: { vm.switchCamera() },
                        onGallery: { showPhotoPicker = true }
                    )
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.bottom, tabState.bottomSafeAreaInset)
            }
            
            
        }
        .ignoresSafeArea()
        .onAppear { vm.startScanning() }
        .onDisappear { vm.stopScanning() }
        .onChange(of: tabState.selection) { _, newValue in
            if newValue == .scan {
                vm.startScanning()
            } else {
                vm.stopScanning()
            }
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPicker(image: $pickedImage)
        }
        .onChange(of: pickedImage) { _, newImage in
            guard let image = newImage else { return }
            vm.processImageQRCode(image)
        }
        
        .fullScreenCover(isPresented: $vm.showResultScreen) {
            resultView.onDisappear { vm.startScanning() }
        }
        
        
    }
    
    private var header: some View {
        VStack {
            Spacer()
            HStack {
                Text(Const.title)
                    .inter(size: 22, style: .semiBold)
                    .padding(.bottom, 16)
                Spacer()
            }
            .padding(.horizontal, 24)
            
        }
        .frame(height: 100)
        .background(Color.appPrimaryBg)
    }
    
    @ViewBuilder
    private var resultView: some View {
        if let result = vm.result {
            switch result {
            case .link(let dto):
                LinkScanResultVC(
                    viewModel: LinkScanResultVM(linkDTO: dto)
                )

            case .wifi:
                ContentView()

            case .contact:
                ContentView()

            case .text:
                ContentView()
            }
        } else {
            EmptyView()
        }
    }
    
}
  
