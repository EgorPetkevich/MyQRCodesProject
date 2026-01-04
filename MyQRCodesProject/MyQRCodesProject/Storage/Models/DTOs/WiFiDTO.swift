//
//  WiFiDTO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import CoreData

struct WiFiDTO: DTODescription, Identifiable {
    
    typealias MO = WiFiMO
    
    var id: String
    var createdAt: Date
    var ssid: String
    var isHidden: Bool
    var password: String?
    var security: String?
    
    init(
        id: String,
        createdAt: Date,
        ssid: String,
        isHidden: Bool,
        password: String?,
        security: String?
    ){
        self.id = id
        self.createdAt = createdAt
        self.ssid = ssid
        self.isHidden = isHidden
        self.password = password
        self.security = security
    }
    
    init?(mo: WiFiMO) {
        guard
            let id = mo.id,
            let createdAt = mo.createdAt,
            let ssid = mo.ssid
        else { return nil }
        self.id = id
        self.createdAt = createdAt
        self.ssid = ssid
        self.isHidden = mo.isHidden
        self.password = mo.password
        self.security = mo.security
    }
    
    func createMO(context: NSManagedObjectContext) -> WiFiMO? {
        let mo = WiFiMO(context: context)
        mo.apply(dto: self)
        return mo
    }
}
