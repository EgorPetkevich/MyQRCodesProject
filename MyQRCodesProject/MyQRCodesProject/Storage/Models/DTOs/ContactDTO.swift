//
//  ContactDTO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import CoreData

struct ContactDTO: DTODescription, Identifiable {
    
    typealias MO = ContactMO
    
    var id: String
    var createdAt: Date
    var scanned: Bool
    var address: String?
    var birthday: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var jobTitle: String?
    var organization: String?
    var phoneNumber: String?
    var phoneNumberWork: String?
    var prefix: String?
    var website: String?
    
    init(id: String,
         createdAt: Date,
         scanned: Bool,
         address: String? = nil,
         birthday: String? = nil,
         email: String? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         jobTitle: String? = nil,
         organization: String? = nil,
         phoneNumber: String? = nil,
         phoneNumberWork: String? = nil,
         prefix: String? = nil,
         website: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.scanned = scanned
        self.address = address
        self.birthday = birthday
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.jobTitle = jobTitle
        self.organization = organization
        self.phoneNumber = phoneNumber
        self.phoneNumberWork = phoneNumberWork
        self.prefix = prefix
        self.website = website
    }
    
    
    init?(mo: ContactMO) {
        guard
            let id = mo.id,
            let createdAt = mo.createdAt
        else { return nil }
        self.id = id
        self.createdAt = createdAt
        self.scanned = mo.scanned
        self.address = mo.address
        self.birthday = mo.birthday
        self.email = mo.email
        self.firstName = mo.firstName
        self.lastName = mo.lastName
        self.jobTitle = mo.jobTitle
        self.organization = mo.organization
        self.phoneNumber = mo.phoneNumber
        self.phoneNumberWork = mo.phoneNumberWork
        self.prefix = mo.prefix
        self.website = mo.website
    }
    
    func createMO(context: NSManagedObjectContext) -> ContactMO? {
        let mo = ContactMO(context: context)
        mo.apply(dto: self)
        return mo
    }
}

extension ContactDTO {
    
    var qrPayload: String {
        var lines: [String] = []
        
        lines.append("BEGIN:VCARD")
        lines.append("VERSION:3.0")
        
        let fullName = [firstName, lastName].compactMap { $0 }.joined(separator: " ")
        lines.append("FN:\(fullName)")
        lines.append("N:\(lastName ?? "");\(firstName ?? "");;;")
        
        if let organization {
            lines.append("ORG:\(organization)")
        }
        
        if let jobTitle {
            lines.append("TITLE:\(jobTitle)")
        }
        
        if let phoneNumber {
            lines.append("TEL;TYPE=CELL:\(phoneNumber)")
        }
        
        if let phoneNumberWork {
            lines.append("TEL;TYPE=WORK:\(phoneNumberWork)")
        }
        
        if let email {
            lines.append("EMAIL:\(email)")
        }
        
        if let website {
            lines.append("URL:\(website)")
        }
        
        if let address {
            lines.append("ADR:;;\(address);;;;")
        }
        
        if let birthday {
            lines.append("BDAY:\(birthday)")
        }
        
        lines.append("END:VCARD")
        
        return lines.joined(separator: "\n")
    }
}
