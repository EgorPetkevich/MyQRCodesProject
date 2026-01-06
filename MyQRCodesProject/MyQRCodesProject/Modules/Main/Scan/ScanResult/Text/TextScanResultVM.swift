//
//  TextScanResultVM.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import UIKit
import Combine

final class TextScanResultVM: ObservableObject {
    
    @Published var showSavedAlert: Bool = false
    
    @Published var showCopiedToast = false
    @Published var showSavedToast = false
    @Published var showShareSheet = false
    @Published var shareItems: [Any] = []
    
    var textDTO: TextDTO
    
    private var storage: TextStorage
    private let qrGenerator: QRCodeGeneratorProtocol
    private let documentManager: DocumentManagerProtocol
    
    private var bag = Set<AnyCancellable>()
    
    init(
        textDTO: TextDTO,
        storage: TextStorage,
        qrGenerator: QRCodeGeneratorProtocol,
        documentManager: DocumentManagerProtocol
    ) {
        self.textDTO = textDTO
        self.storage = storage
        self.qrGenerator = qrGenerator
        self.documentManager = documentManager
    }
    
    func actionButtonDidTap() {
        copyButtonDidTap()
    }
    
    func saveButtonDidTap() {
        storage.save(dto: textDTO)
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
        guard let qrImage = qrGenerator.generate(from: textDTO.qrPayload) else {
            print("[QR]: Failed to generate image")
            return
        }

        documentManager.saveQr(image: qrImage, with: textDTO.id)
    }

    func copyButtonDidTap() {
        UIPasteboard.general.string = textDTO.text
        showCopiedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showCopiedToast = false
        }
    }
    
    func shareDidTap() {
        shareItems = [textDTO.text]
        showShareSheet = !shareItems.isEmpty
    }
    
}
