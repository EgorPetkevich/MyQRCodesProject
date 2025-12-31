//
//  PaywallViewModel.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 30.12.25.
//

import UIKit
import Combine

protocol ApphudServicePaywallUseCase {

    func getProduct(with type: ProductType) -> PaywallProduct?
    func restorePurchases() async throws -> Bool
    func makePurchase(
        product: PaywallProduct,
        completion: @escaping (Result<Void, ApphudError>) -> Void
    )
}

final class PaywallViewModel: ObservableObject {
    
    @Published var showErrorAlert: Bool = false
    @Published var finish: Bool = false
    @Published var selectedProduct: ProductType = .weekly
    var errorMessage: String = ""
    
    var continueDidTap:  PassthroughSubject<Void, Never> = .init()
    var crossDidTap:  PassthroughSubject<Void, Never> = .init()
    var termsDidTap:  PassthroughSubject<Void, Never> = .init()
    var privacyDidTap:  PassthroughSubject<Void, Never> = .init()
    var restoredidTap:  PassthroughSubject<Void, Never> = .init()
    
    var weeklyProduct: PaywallProduct?
    var monthlyProduct: PaywallProduct?
    
    private let apphudService: ApphudServicePaywallUseCase
    
    private var bag: Set<AnyCancellable> = []
    
    init(apphudService: ApphudServicePaywallUseCase) {
        self.apphudService = apphudService
        commonInit()
        bind()
    }
    
    private func commonInit() {
        weeklyProduct = apphudService.getProduct(with: .weekly)
        monthlyProduct = apphudService.getProduct(with: .monthly)
    }
    
    private func bind() {
        continueDidTap
            .sink(receiveValue: { [weak self] in
                self?.makePurchase()
            })
            .store(in: &bag)
        crossDidTap
            .sink(receiveValue: { [weak self] in
                self?.finish = true
            })
            .store(in: &bag)
        privacyDidTap
            .sink(receiveValue: {
                UIApplication.open(strUrl: Constants.privacyUrl)
            })
            .store(in: &bag)
        termsDidTap
            .sink(receiveValue: {
                UIApplication.open(strUrl: Constants.termsUrl)
            })
            .store(in: &bag)
        restoredidTap
            .sink(receiveValue: { [weak self] in
                self?.restorePurchase()
            })
            .store(in: &bag)
    }
    
}

//Apphud
private extension PaywallViewModel {
    
    func makePurchase() {
        guard
            let apphudProduct = getSelectedProduct()
        else { return showErrorAlert = true }
        
        Task { @MainActor in
            apphudService
                .makePurchase(product: apphudProduct) { [weak self] result in
                    switch result {
                    case .success:
                        self?.finish = true
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        DispatchQueue.main.async {
                            self?.showErrorAlert = true
                        }
                    }
                }
        }
    }
    
    func getSelectedProduct() -> PaywallProduct? {
        selectedProduct == .weekly ? weeklyProduct : monthlyProduct
    }
    
    func restorePurchase() {
        Task {
            let success = try await apphudService.restorePurchases()
            guard success else { return showErrorAlert = true }
            finish = true
        }
    }
}

