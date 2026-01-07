//
//  LinkMO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation

extension LinkMO: MODescription {
    
    func apply(dto: any DTODescription) {
        guard let linkDTO = dto as? LinkDTO else {
            print("[MODTO]", "\(Self.self) apply failsed: dto is type of \(Swift.type(of: dto))")
            return
        }
        self.id = linkDTO.id
        self.createdAt = linkDTO.createdAt
        self.scanned = linkDTO.scanned
        self.link = linkDTO.link
    }
    
    func toDTO() -> (any DTODescription)? {
        LinkDTO(mo: self)
    }
    
    
}
