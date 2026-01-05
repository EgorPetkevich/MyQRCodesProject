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
    
    var textDTO: TextDTO
    
    private var storage: TextStorage
    
    private var bag = Set<AnyCancellable>()
    
    init(textDTO: TextDTO, storage: TextStorage) {
        self.textDTO = textDTO
        self.storage = storage
    }
    
    func actionButtonDidTap() {
        copyButtonDidTap()
    }
    
    func saveButtonDidTap() {
        storage.save(dto: textDTO)
            .catch { error in
                print("[Storage]: \(error.localizedDescription)")
                return Just(())
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showSavedToast = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.showSavedToast = false
                }
            }
            .store(in: &bag)
    }

    func copyButtonDidTap() {
        UIPasteboard.general.string = textDTO.text
        showCopiedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showCopiedToast = false
        }
    }
    
    func shareDidTap() {
        let str = textDTO.text
        let activityVC = UIActivityViewController(activityItems: [str],
                                                  applicationActivities: nil)
        if let scene =
            UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true)
        }
    }
    
}
