//
//  LinkDTO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import CoreData

struct LinkDTO: DTODescription, Identifiable {
    
    typealias MO = LinkMO
    
    var id: String
    var link: String
    var createdAt: Date
    var scanned: Bool
    var qrPayload: String {
        link
    }
    
    init(id: String, link: String, createdAt: Date, scanned: Bool){
        self.id = id
        self.link = link
        self.createdAt = createdAt
        self.scanned = scanned
    }
    
    init?(mo: LinkMO) {
        guard
            let id = mo.id,
            let link = mo.link,
            let createdAt = mo.createdAt
        else { return nil }
        self.id = id
        self.link = link
        self.createdAt = createdAt
        self.scanned = mo.scanned
    }
    
    func createMO(context: NSManagedObjectContext) -> LinkMO? {
        let mo = LinkMO(context: context)
        mo.apply(dto: self)
        return mo
    }
}

