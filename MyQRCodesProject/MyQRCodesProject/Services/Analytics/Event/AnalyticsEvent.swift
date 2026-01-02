//
//  AnalyticsEvent.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 2.01.26.
//

import Foundation

enum AnalyticsEvent {

    case appOpen
    case onboardingComplete
    case paywallShown(id: String)
    case purchase(productId: String, price: Double, currency: String)
    case attStatusChanged(status: String)

    var name: String {
        switch self {
        case .appOpen: return "app_open"
        case .onboardingComplete: return "onboarding_complete"
        case .paywallShown: return "paywall_shown"
        case .purchase: return "purchase"
        case .attStatusChanged: return "att_status_changed"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .appOpen:
            return [:]

        case .onboardingComplete:
            return [:]

        case .paywallShown(let id):
            return ["paywall_id": id]

        case .purchase(let productId, let price, let currency):
            return [
                "product_id": productId,
                "price": price,
                "currency": currency
            ]
        case .attStatusChanged(let status):
            return ["status": status]
        }
    }
}

///AnalyticsService.shared.track(.appOpen)
///
///AnalyticsService.shared.track(.paywallShown(id: "main"))
///
///AnalyticsService.shared.track(
///    .purchase(
///        productId: product.identifier,
///        price: product.price,
///        currency: product.currencyCode
///    )
///)
