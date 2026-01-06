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
    
    private let storage: BaseStorage<DTO>
    
    private let qrGenerator: QRCodeGeneratorProtocol
    private let documentManager: DocumentManagerProtocol
    
    private var bag: Set<AnyCancellable> = []

    init(
        dto: DTO,
        storage: BaseStorage<DTO>,
        qrGenerator: QRCodeGeneratorProtocol,
        documentManager: DocumentManagerProtocol
    ) {
        self.dto = dto
        self.storage = storage
        self.qrGenerator = qrGenerator
        self.documentManager = documentManager
        
        commonInit()
    }
    
    private func commonInit() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            getQrCodeImage()
        }
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
                    
                    self.generateQrAndSave()
                    self.showSavedToast = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showSavedToast = false
                    }
                    
                }
            )
            .store(in: &bag)
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
