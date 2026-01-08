//
//  AnalyticsEvent.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import Foundation

enum AnalyticsEvent {

    // MARK: - App lifecycle
    case appLaunched(isFirstLaunch: Bool)
    case appOpen
    case attStatusChanged(status: String)

    // MARK: - Onboarding / Paywall
    case onboardingComplete
    case paywallShown(id: String)
    case purchase(productId: String, price: String)

    // MARK: - Generate flow
    case qrCodeDidSaved(byId: String)

    // MARK: - Ads
    case showInterstitialAd

    var name: String {
        switch self {
        case .appLaunched:
            return "app_launched"
        case .appOpen:
            return "app_open"
        case .onboardingComplete:
            return "onboarding_complete"
        case .paywallShown:
            return "paywall_shown"
        case .purchase:
            return "purchase"
        case .attStatusChanged:
            return "att_status_changed"
        case .qrCodeDidSaved:
            return "qrcode_did_saved"
        case .showInterstitialAd:
            return "show_interstitial_ad"
        }
    }

    var parameters: [String: Any]? {
        switch self {

        case .appLaunched(let isFirstLaunch):
            return ["first_launch": isFirstLaunch]

        case .appOpen:
            return nil

        case .onboardingComplete:
            return nil

        case .paywallShown(let id):
            return ["paywall_id": id]

        case .purchase(let productId, let price):
            return [
                "product_id": productId,
                "price": price,
            ]

        case .attStatusChanged(let status):
            return ["status": status]

        case .qrCodeDidSaved(let byId):
            return ["qr_id": byId]

        case .showInterstitialAd:
            return ["ad_type": "interstitial"]
        }
    }
}
