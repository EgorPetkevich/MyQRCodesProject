//
//  ApphudError.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import Foundation

enum ApphudError: Error, LocalizedError {
    case productNotFound
    case purchaseFailed
    case restoreFailed
    case remoteConfigFetchFailed
    case paywallsFetchFailed
    case unknownPurchaseError

    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Product not found."
        case .purchaseFailed:
            return "Purchase failed."
        case .restoreFailed:
            return "Failed to restore purchases."
        case .remoteConfigFetchFailed:
            return "Failed to fetch Remote Config."
        case .paywallsFetchFailed:
            return "Failed to fetch paywalls."
        case .unknownPurchaseError:
            return "An unknown error occurred during purchase."
        }
    }
}
