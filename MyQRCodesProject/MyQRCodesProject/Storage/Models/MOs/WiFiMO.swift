//
//  WiFiMO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation

extension WiFiMO: MODescription {
    
    func apply(dto: any DTODescription) {
        guard let wifiDTO = dto as? WiFiDTO else {
            print("[MODTO]", "\(Self.self) apply failsed: dto is type of \(Swift.type(of: dto))")
            return
        }
        self.id = wifiDTO.id
        self.createdAt = wifiDTO.createdAt
        self.ssid = wifiDTO.ssid
        self.isHidden = wifiDTO.isHidden
        self.password = wifiDTO.password
        self.security = wifiDTO.security
    }
    
    func toDTO() -> (any DTODescription)? {
        WiFiDTO(mo: self)
    }
    
    
}
