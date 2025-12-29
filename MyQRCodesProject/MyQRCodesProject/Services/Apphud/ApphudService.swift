//
//  ApphudService.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import Foundation
import ApphudSDK
import Network

enum PaywallType: String {
    case main = "main_paywall"
}

enum ProductType {
    case weekly
    case monthly
    case yearly
    
    var decodingName: String {
        switch self {
        case .weekly:
            return "sonicforge_weekly"
        case .monthly:
            return "sonicforge_monthly"
        case .yearly:
            return "sonicforge_yearly"
        }
    }
}

final class ApphudService {
    
//    private enum Const {
//        static let trialKeyword = "trial"
//    }
    
    enum PaywallLoadState: Equatable {
        case idle
        case loading(attempt: Int)
        case loaded
        case failed(ApphudError)
    }
    
    //Published Properties (Outputs)
    @Published var config = PaywallConfig()
    @Published var products: [PaywallProduct] = []
    @Published var paywallType: PaywallType = .main
    
    @Published private(set) var paywallLoadState: PaywallLoadState = .idle
    
    
    static let instance = ApphudService()
    
    private init() {}
    
}

// MARK: - Public API

extension ApphudService {
    
//    func isTrialAvailable() -> Bool {
//        products.contains { $0.id.contains(Const.trialKeyword) }
//    }
    
    func getProduct(with type: ProductType) -> PaywallProduct? {
        products.first {
            return $0.id.contains(type.decodingName)
        }
    }
    
    func hasActiveSubscription() -> Bool {
        Apphud.hasActiveSubscription()
    }
   
    func loadPaywallDataOrFalse(for id: PaywallType) async -> Bool {
        do {
            return try await loadPaywallData(for: id)
        } catch {
            print(error)
            return false
        }
    }
    
    @discardableResult
       func loadPaywallWithRetry(
           id: PaywallType,
           maxAttempts: Int = 3,
           baseDelay: Double = 1.0,
           maxDelay: Double = 8.0,
           jitterFactor: Double = 0.4
       ) async -> Bool {

           if case .loaded = paywallLoadState { return true }

           for attempt in 1...maxAttempts {
               if Task.isCancelled { return false }

               paywallLoadState = .loading(attempt: attempt)

               let success = await loadPaywallDataOrFalse(for: id)
               if success {
                   paywallLoadState = .loaded
                   return true
               }

               let backoff = min(maxDelay, baseDelay * pow(2.0, Double(attempt - 1)))
               let jitter = Double.random(in: 0...(jitterFactor * backoff))
               let delay = backoff + jitter

               try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
           }

           paywallLoadState = .failed(.paywallsFetchFailed)
           return false
       }
    
    @MainActor
    func makePurchase(
        product: ApphudProduct,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        Apphud.purchase(product) { result in
            if let subscription = result.subscription, subscription.isActive() {
                completion(.success(()))
            } else {
                completion(.failure(result.error ?? ApphudError.unknownPurchaseError))
            }
        }
    }
    
    @MainActor
    func restorePurchases() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            Apphud.restorePurchases { result, _, error  in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let hasAccess = Apphud.hasPremiumAccess()
                
                if hasAccess {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(throwing: ApphudError.restoreFailed)
                }
            }
        }
    }
    
}

//MARK: - Private

private extension ApphudService {
    
    
    @MainActor
    @discardableResult
    func loadPaywallData(for id: PaywallType) async throws -> Bool {
        guard await isNetworkReachable() else {
            throw ApphudError.remoteConfigFetchFailed
        }
        guard let paywall = await fetchPaywall(for: id) else {
            throw ApphudError.paywallsFetchFailed
        }
        
        self.products = await paywall.products.asyncMap { await PaywallProduct(product: $0) }
//        self.config = try decodeConfig(from: paywall)
        
        return true
    }
    
    @MainActor
    private func fetchPaywall(for id: PaywallType) async -> ApphudPaywall? {
        self.paywallType = id
        
        return await withCheckedContinuation { (continuation: CheckedContinuation<ApphudPaywall?, Never>) in
            Apphud.paywallsDidLoadCallback { paywalls, _ in
                let paywall = paywalls
                    .first(where: { $0.identifier == id.rawValue })
                continuation.resume(returning: paywall)
            }
        }
    }
    
    func decodeConfig(from paywall: ApphudPaywall) throws -> PaywallConfig {
        guard let json = paywall.json else {
            throw ApphudError.remoteConfigFetchFailed
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PaywallConfig.self, from: data)
        } catch {
            throw ApphudError.remoteConfigFetchFailed
        }
    }
    
    func isNetworkReachable() async -> Bool {
        await withCheckedContinuation { cont in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "net.monitor")
            monitor.pathUpdateHandler = { path in
                cont.resume(returning: path.status == .satisfied)
                monitor.cancel()
            }
            monitor.start(queue: queue)
        }
    }
   
    
}


import StoreKit

struct PaywallProduct: Identifiable {
    let id: String
    let price: String?
    let period: Product.SubscriptionPeriod.Unit.FormatStyle?
    let apphudProduct: ApphudProduct?

    init(product: ApphudProduct) async {
        self.id = product.productId
        self.price = product.skProduct?.formattedPrice
        self.period = try? await product.product()?.subscriptionPeriodUnitFormatStyle
        self.apphudProduct = product
    }
}

struct PaywallConfig: Decodable {
    
    var onboardingCloseDelay: Double = 0
    var paywallCloseDelay: Double = 0
    var onboardingButtonTitle: String?
    var paywallButtonTitle: String?
    var onboardingSubtitleAlpha: Double = 1.0
    var isPagingEnabled: Bool = false
    var isReviewEnabled: Bool = false
    
}

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

extension Sequence {
    
    func asyncMap<T>(_ transform: (Element) async -> T) async -> [T] {
        var results = [T]()
        for element in self {
            results.append(await transform(element))
        }
        return results
    }
    
}

extension SKProduct {
    
    var formattedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
    
}
