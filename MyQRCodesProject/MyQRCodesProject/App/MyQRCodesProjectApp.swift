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

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    @AppStorage(.onboardingPassed) private var onboardingPassed: Bool = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var configLoaded = false
    @State private var isLoadingPaywall = false
    @State private var showErrorAlert = false
    @State private var afterOnbording = false
    @State private var wasInBackground = false
    
    @State private var showInAppPaywall = false
    @State private var isPaywallVisible = false
    
    private let persistence = PersistenceController.shared
    private let apphudService: ApphudService = .instance
    private let analyticsService = AnalyticsService()
    
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
                .fullScreenCover(
                    isPresented: $showInAppPaywall,
                    onDismiss: { isPaywallVisible = false }
                ) {
                    PaywallVC(viewModel: PaywallViewModel(apphudService: apphudService))
                }
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    switch newPhase {
                    case .background:
                        wasInBackground = true
                    case .active:
                        guard wasInBackground else { return }
                        wasInBackground = false
                        coverInAppPaywall()
                    default:
                        break
                    }
                }
                .onChange(of: configLoaded) { oldValue, newValue in
                    if newValue && !afterOnbording { coverInAppPaywall() }
                }
                .onChange(of: onboardingPassed) { _, newValue in
                    if newValue {
                        afterOnbording = true
                        configLoaded = false
                        loadInAppPaywall()
                    }
                }
        }
    }
    
    init() {
        onFirstLaunch()
        Apphud.start(apiKey: Constants.apphudKey)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if isLoadingPaywall || !configLoaded {
            LounchScreen()
        } else if onboardingPassed {
            TabBarVC(apphudService: apphudService)
        } else {
            OnbFirstScreenVC()
                .withRouter(OnbRouter())
        }
    }
    
    private func onFirstLaunch() {
        let isFirstLaunch = !UDManager.get(.didLaunchBefore)
        createQRCodeImagesDirectoryIfNeeded()
        UDManager.set(.didLaunchBefore, value: true)
        analyticsService.track(.appLaunched(isFirstLaunch: isFirstLaunch))
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
    
    private func loadInAppPaywall() {
        if apphudService.hasActiveSubscription() {
            configLoaded = true
            return
        }
        
        guard !isLoadingPaywall else { return }
        isLoadingPaywall = true

        Task {
            defer { isLoadingPaywall = false }

            let success = await apphudService.loadPaywallDataOrFalse(for: .main)
            if success {
                configLoaded = true
            } else {
                showErrorAlert = true
            }
        }
    }
    
    private func coverInAppPaywall() {
        guard configLoaded && onboardingPassed else { return }
        guard !apphudService.hasActiveSubscription(),
              !isPaywallVisible
        else { return }
        analyticsService.track(.paywallShown(id: PaywallType.main.rawValue))
        isPaywallVisible = true
        showInAppPaywall = true
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
