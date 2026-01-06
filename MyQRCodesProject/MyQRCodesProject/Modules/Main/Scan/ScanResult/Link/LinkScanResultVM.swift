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
    
    var linkDTO: LinkDTO
    
    private var storage: LinkStorage
    private let qrGenerator: QRCodeGeneratorProtocol
    private let documentManager: DocumentManagerProtocol
    
    private var bag = Set<AnyCancellable>()
    
    init(
        linkDTO: LinkDTO,
        storage: LinkStorage,
        qrGenerator: QRCodeGeneratorProtocol,
        documentManager: DocumentManagerProtocol
    ) {
        self.linkDTO = linkDTO
        self.storage = storage
        self.qrGenerator = qrGenerator
        self.documentManager = documentManager
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
        guard let qrImage = qrGenerator.generate(from: linkDTO) else {
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
       
        let activityVC = UIActivityViewController(activityItems: [url],
                                                  applicationActivities: nil)
        if let scene =
            UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true)
        }
    }
    
}
