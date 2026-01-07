//
//  LinkMO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation

extension TextMO: MODescription {
    
    func apply(dto: any DTODescription) {
        guard let textDTO = dto as? TextDTO else {
            print("[MODTO]", "\(Self.self) apply failsed: dto is type of \(Swift.type(of: dto))")
            return
        }
        self.id = textDTO.id
        self.createdAt = textDTO.createdAt
        self.scanned = textDTO.scanned
        self.text = textDTO.text
    }
    
    func toDTO() -> (any DTODescription)? {
        TextDTO(mo: self)
    }
    
    
}
