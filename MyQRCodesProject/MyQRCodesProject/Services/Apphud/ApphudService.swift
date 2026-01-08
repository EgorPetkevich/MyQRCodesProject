//
//  ApphudService.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import Foundation
import ApphudSDK
import Network

final class ApphudService {
    
    enum PaywallLoadState: Equatable {
        case idle
        case loading(attempt: Int)
        case loaded
        case failed(ApphudError)
    }
    
    @Published var products: [PaywallProduct] = []
    @Published var paywallType: PaywallType = .main
    
    @Published private(set) var paywallLoadState: PaywallLoadState = .idle
    
    private let analyticService = AnalyticsService.shared
    static let instance = ApphudService()
    
    private init() {}
    
}

// MARK: - Public API

extension ApphudService {
    
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
        product: PaywallProduct,
        completion: @escaping (Result<Void, ApphudError>) -> Void
    ) {
        
        guard let apphudProduct = product.apphudProduct else {
            completion(.failure(ApphudError.unknownPurchaseError))
            return
        }
        
        Apphud.purchase(apphudProduct) { result in
            if let subscription = result.subscription, subscription.isActive() {
                self.analyticService.track(.purchase(productId: product.id, price: product.price ?? ""))
                completion(.success(()))
            } else {
                completion(.failure(ApphudError.unknownPurchaseError))
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
