//
//  ContactScanResultVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import UIKit
import Combine

final class ContactScanResultVM: ObservableObject {
    
    @Published var showSavedAlert: Bool = false
    @Published var showCallErrorAlert: Bool = false
    @Published var showShareSheet = false
    @Published var shareURL: URL?
    
    @Published var showCopiedToast = false
    @Published var showSavedToast = false
    
    var contactDTO: ContactDTO
    
    private var storage: ContactStorage
    private let qrGenerator: QRCodeGeneratorProtocol
    private let documentManager: DocumentManagerProtocol
    
    private var bag = Set<AnyCancellable>()
    
    init(
        contactDTO: ContactDTO,
        storage: ContactStorage,
        qrGenerator: QRCodeGeneratorProtocol,
        documentManager: DocumentManagerProtocol
    ) {
        self.contactDTO = contactDTO
        self.storage = storage
        self.qrGenerator = qrGenerator
        self.documentManager = documentManager
    }
    
    func actionButtonDidTap() {
        if let phoneNumber = contactDTO.phoneNumber,
           let url = URL(string: "tel:\(phoneNumber)")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showCallErrorAlert = true
        }
    }
    
    func saveButtonDidTap() {
        storage.save(dto: contactDTO)
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
                    self.showSavedToast = true
                    UDManager.appendResentId(contactDTO.id)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showSavedToast = false
                    }
                    
                }
            )
            .store(in: &bag)
    }
    
    private func generateQrAndSave() {
        guard let qrImage = qrGenerator.generate(from: contactDTO.qrPayload) else {
            print("[QR]: Failed to generate image")
            return
        }

        documentManager.saveQr(image: qrImage, with: contactDTO.id)
    }
    
    func copyButtonDidTap() {
        UIPasteboard.general.string = contactDTO.phoneNumber
        showCopiedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showCopiedToast = false
        }
    }
    
    func shareDidTap() {
        let vCard = qrGenerator.makeVCard(from: contactDTO)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("contact.vcf")

        do {
            try vCard.write(to: url, atomically: true, encoding: .utf8)

            DispatchQueue.main.async {
                self.shareURL = url
                self.showShareSheet = true
            }
        } catch {
            print("Failed to share:", error)
        }
    }
    
}
