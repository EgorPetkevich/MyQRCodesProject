//
//  QrCodePreviewVM.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import UIKit
import Combine

final class CreatedQrPreviewVM<DTO: DTODescription>: ObservableObject {
    
    @Published var showSavedToast = false
    @Published var qrImage: UIImage?
    @Published var shareURL: URL?
    @Published var showShareSheet = false
    @Published var shareItems: [Any] = []
    
    private let dto: DTO
    private let designImage: UIImage?
    private let showAds: Bool
    
    private let storage: BaseStorage<DTO>
    
    private let qrGenerator: QRCodeGeneratorProtocol
    private let documentManager: DocumentManagerProtocol
    private let analytics: AnalyticsServiceProtocol
    private let adManagerService: AdManagerServiceProtocol
    private let apphudService: ApphudService = .instance
    
    private var bag: Set<AnyCancellable> = []

    init(
        dto: DTO,
        showAds: Bool,
        designImage: UIImage?,
        storage: BaseStorage<DTO>,
        qrGenerator: QRCodeGeneratorProtocol,
        documentManager: DocumentManagerProtocol,
        analytics: AnalyticsServiceProtocol,
        adManagerService: AdManagerServiceProtocol
    ) {
        self.dto = dto
        self.showAds = showAds
        self.designImage = designImage
        self.storage = storage
        self.qrGenerator = qrGenerator
        self.documentManager = documentManager
        self.analytics = analytics
        self.adManagerService = adManagerService
        commonInit()
    }
    
    private func commonInit() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            getQrCodeImage()
        }
    }
    
    func onAppear() {
        guard !apphudService.hasActiveSubscription(), showAds else { return }
        adManagerService.showInterstitialAd()
        analytics.track(.showInterstitialAd)
    }
    
    func getQrCodeImage()  {
        guard
            let image = qrGenerator.generate(from: dto.qrPayload)
        else { return }
        qrImage = image
    }
    
    func shareDidTap() {
        switch dto {
        case let wifiDTO as WiFiDTO:
            shareItems = [wifiText(from: wifiDTO)]
        case let textDTO as TextDTO:
            shareItems = [textDTO.text]
        case let linkDTO as LinkDTO:
            if let url = URL(string: linkDTO.link) {
                shareItems = [url]
            }
        case let contactDTO as ContactDTO:
            shareContactDTO(contactDTO)
        default:
            return
        }
        
        showShareSheet = !shareItems.isEmpty
    }

    
    func saveDidTap() {
        storage.save(dto: dto)
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
                    UDManager.appendResentId(dto.id)
                    self.saveDesignImage()
                    self.showSavedToast = true
                    self.analytics.track(.qrCodeDidSaved(byId: dto.id))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showSavedToast = false
                    }
                    
                }
            )
            .store(in: &bag)
    }
    
    private func saveDesignImage() {
        guard let designImage else {
            print("[DesignImage]: Optional image is nil")
            return
        }
        documentManager.saveBg(image: designImage, with: dto.id)
    }
    
    private func generateQrAndSave() {
        guard let qrImage = qrGenerator.generate(from: dto.qrPayload) else {
            print("[QR]: Failed to generate image")
            return
        }

        documentManager.saveQr(image: qrImage, with: dto.id)
    }

    // MARK: - Private helpers
   
    private func shareContactDTO(_ contactDTO: ContactDTO) {
        let vCard = qrGenerator.makeVCard(from: contactDTO)
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("contact.vcf")
        
        do {
            try vCard.write(to: url, atomically: true, encoding: .utf8)
            
            DispatchQueue.main.async {
                self.shareItems = [url]
            }
        } catch {
            print("Failed to share:", error)
        }
    }

    private func wifiText(from wifiDTO: WiFiDTO) -> String {
         """
         Wi-Fi Network
         SSID: \(wifiDTO.ssid)
         Security: \(wifiDTO.securityDisplayName)
         Password: \(wifiDTO.password ?? "—")
         """
     }
    
}
