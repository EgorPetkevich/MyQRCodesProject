//
//  LinkScanResultVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import UIKit
import Combine

final class LinkScanResultVM: ObservableObject {
    
    @Published var showSavedAlert: Bool = false
    
    @Published var showCopiedToast = false
    @Published var showSavedToast = false
    @Published var showShareSheet = false
    @Published var shareItems: [Any] = []
    
    var linkDTO: LinkDTO
    private let showAds: Bool
    
    private var storage: LinkStorage
    private let qrGenerator: QRCodeGeneratorProtocol
    private let documentManager: DocumentManagerProtocol
    private let analytics: AnalyticsServiceProtocol
    private let adManagerService: AdManagerServiceProtocol
    private let apphudService: ApphudService = .instance
    
    private var bag = Set<AnyCancellable>()
    
    init(
        linkDTO: LinkDTO,
        showAds: Bool,
        storage: LinkStorage,
        qrGenerator: QRCodeGeneratorProtocol,
        documentManager: DocumentManagerProtocol,
        analytics: AnalyticsServiceProtocol,
        adManagerService: AdManagerServiceProtocol
    ) {
        self.linkDTO = linkDTO
        self.showAds = showAds
        self.storage = storage
        self.qrGenerator = qrGenerator
        self.documentManager = documentManager
        self.analytics = analytics
        self.adManagerService = adManagerService
    }
    
    func onAppear() {
        guard !apphudService.hasActiveSubscription(), showAds else { return }
        adManagerService.showInterstitialAd()
        analytics.track(.showInterstitialAd)
    }
    
    func actionButtonDidTap() {
        UIApplication.open(strUrl: linkDTO.link)
    }
    
    func saveButtonDidTap() {
        storage.save(dto: linkDTO)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("[Storage]: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] in
                    guard let self else { return }
                    
//                    self.generateQrAndSave()
                    UDManager.appendResentId(linkDTO.id)
                    self.showSavedToast = true
                    self.analytics.track(.qrCodeDidSaved(byId: linkDTO.id))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showSavedToast = false
                    }
                    
                }
            )
            .store(in: &bag)
    }
    
    private func generateQrAndSave() {
        guard let qrImage = qrGenerator.generate(from: linkDTO.qrPayload) else {
            print("[QR]: Failed to generate image")
            return
        }

        documentManager.saveQr(image: qrImage, with: linkDTO.id)
    }

    func copyButtonDidTap() {
        UIPasteboard.general.string = linkDTO.link
        showCopiedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showCopiedToast = false
        }
    }
    
    func shareDidTap() {
        guard let url = URL(string: linkDTO.link) else { return }
        shareItems = [url]
        showShareSheet = !shareItems.isEmpty
    }
    
}
