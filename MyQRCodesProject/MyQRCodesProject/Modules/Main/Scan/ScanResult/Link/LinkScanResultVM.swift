//
//  LinkScanResultVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation

final class LinkScanResultVM: ObservableObject {
    
    var linkDTO: LinkDTO
    
    init(linkDTO: LinkDTO) {
        self.linkDTO = linkDTO
    }
    
}
