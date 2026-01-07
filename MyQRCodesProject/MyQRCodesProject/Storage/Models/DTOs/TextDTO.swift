//
//  LinkDTO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import CoreData

struct TextDTO: DTODescription, Identifiable {
    
    typealias MO = TextMO
    
    var id: String
    var text: String
    var createdAt: Date
    var scanned: Bool
    var qrPayload: String {
        text
    }
    
    init(id: String, text: String, createdAt: Date, scanned: Bool){
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.scanned = scanned
    }
    
    init?(mo: TextMO) {
        guard
            let id = mo.id,
            let text = mo.text,
            let createdAt = mo.createdAt
        else { return nil }
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.scanned = mo.scanned
    }
    
    func createMO(context: NSManagedObjectContext) -> TextMO? {
        let mo = TextMO(context: context)
        mo.apply(dto: self)
        return mo
    }
}
