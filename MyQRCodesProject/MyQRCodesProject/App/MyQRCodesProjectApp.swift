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
    
    @AppStorage(.onboardingPassed) private var onboardingPassed: Bool = false
    
    @State private var configLoaded = false
    @State private var isLoadingPaywall = false
    @State private var showErrorAlert = false
    
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
        }
    }
    
    init() {
        Apphud.start(apiKey: Constants.apphudKey)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if isLoadingPaywall || !configLoaded {
            LounchScreen()
        } else if onboardingPassed {
            PaywallVC(viewModel: PaywallViewModel(apphudService: apphudService))
        } else {
            OnbFirstScreenVC()
                .withRouter(OnbRouter())
        }
    }
    
    func initializeApphud() {
        guard
            !apphudService.hasActiveSubscription()
        else { return configLoaded = true }
        
        loadPaywall(for: .main)
    }
    
    func loadPaywall(for id: PaywallType) {
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
    
    
}

private extension MyQRCodesProjectApp {
    enum ErrorAlert {
        static let title: String = "Oops..."
        static let tryButtonTitle: String = "Try Again"
        static let cancelButtonTitle: String = "Cancel"
        static let textMessage: String = "Something went wrong.\nPlease try again."
    }
}
