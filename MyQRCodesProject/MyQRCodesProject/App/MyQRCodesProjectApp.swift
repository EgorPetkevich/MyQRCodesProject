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
    
    private let apphudService: ApphudService = .instance
    
    var body: some Scene {
        WindowGroup {
            contentView
                .task {
                    initializeApphud()
                }
        }
    }
    
    init() {
//        Apphud.start(apiKey: Constants.apphudKey)
    }
    
    @ViewBuilder
    private var contentView: some View {
        
//        if onboardingPassed {
//            LounchScreen()
//        } else {
            OnbFirstScreenVC()
                .withRouter(OnbRouter())
//        }
        
       
    }
    
    func initializeApphud() {
        guard
            !apphudService.hasActiveSubscription()
        else { return }
        
        Task {
            let success = await apphudService.loadPaywallDataOrFalse(for: .main)
            if success {
                print("Success")
            } else {
                print("Error")
            }
        }
        
    }
    
    
}
