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
    
    var linkDTO: LinkDTO
    
    private var storage: LinkStorage
    
    private var bag = Set<AnyCancellable>()
    
    init(linkDTO: LinkDTO, storage: LinkStorage) {
        self.linkDTO = linkDTO
        self.storage = storage
    }
    
    func actionButtonDidTap() {
        UIApplication.open(strUrl: linkDTO.link)
    }
    
    func saveButtonDidTap() {
        storage.save(dto: linkDTO)
            .catch { error in
                print("[Storage]: \(error.localizedDescription)")
                return Just(())
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showSavedAlert = true
            }
            .store(in: &bag)
        
    }
    
    func copyButtonDidTap() {
        
    }
    
    func shareDidTap() {
        
    }
    
}
