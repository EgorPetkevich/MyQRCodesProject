//
//  MyQRCodesProjectApp.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI
import ApphudSDK

@main
struct MyQRCodesProjectApp: App {
    //FIXME: uncomment the line below
//    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    @AppStorage(.onboardingPassed) private var onboardingPassed: Bool = false
    
    @State private var configLoaded = false
    @State private var isLoadingPaywall = false
    @State private var showErrorAlert = false
    
    private let persistence = PersistenceController.shared
    private let apphudService: ApphudService = .instance
    
    var body: some Scene {
        WindowGroup {
            contentView
                .task {
                    initializeApphud()
                }
                .alert(ErrorAlert.title, isPresented: $showErrorAlert) {
                    Button(ErrorAlert.tryButtonTitle) {
                        Task { initializeApphud() }
                    }
                    Button(ErrorAlert.cancelButtonTitle, role: .cancel) { }
                } message: {
                    Text(ErrorAlert.textMessage)
                }
                .onReceive(
                    NotificationCenter.default
                        .publisher(for: UIApplication.didBecomeActiveNotification)
                ) { _ in
                    
                }
        }
    }
    
    init() {
        createQRCodeImagesDirectoryIfNeeded()
        //FIXME: uncomment the line below
//        Apphud.start(apiKey: Constants.apphudKey)
    }
    
    @ViewBuilder
    private var contentView: some View {
        //FIXME: uncomment the condition below
//        if isLoadingPaywall || !configLoaded {
//            LounchScreen()
//        } else if onboardingPassed {
//            TabBarVC(apphudService: apphudService)
//        } else {
//            OnbFirstScreenVC()
//                .withRouter(OnbRouter())
//        }
        //FIXME: remove the line below
        TabBarVC(apphudService: apphudService)
    }
    
    private func initializeApphud() {
        guard
            !apphudService.hasActiveSubscription()
        else { return configLoaded = true }
        
        loadPaywall(for: .main)
    }
    
    private func loadPaywall(for id: PaywallType) {
        guard !isLoadingPaywall else { return }
        isLoadingPaywall = true

        Task {
            defer { isLoadingPaywall = false }

            let success = await apphudService.loadPaywallWithRetry(id: id)
            if success {
                configLoaded = true
            } else {
                showErrorAlert = true
            }
        }
    }
    
    private func createQRCodeImagesDirectoryIfNeeded() {
        if !UDManager.get(.createQrCodeImagesDirectory) {
            DocumentManager.createDirectory(name: .qrImages)
            DocumentManager.createDirectory(name: .bgImages)
            UDManager.set(.createQrCodeImagesDirectory, value: true)
        }
    }
    
}

private extension MyQRCodesProjectApp {
    enum ErrorAlert {
        static let title: String = "Oops..."
        static let tryButtonTitle: String = "Try Again"
        static let cancelButtonTitle: String = "Cancel"
        static let textMessage: String = "Something went wrong.\nPlease try again."
    }
}
