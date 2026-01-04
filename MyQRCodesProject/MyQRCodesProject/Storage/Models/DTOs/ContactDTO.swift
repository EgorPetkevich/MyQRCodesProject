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
         address: String?,
         birthday: String?,
         email: String?,
         firstName: String?,
         lastName: String?,
         jobTitle: String?,
         organization: String?,
         phoneNumber: String?,
         phoneNumberWork: String?,
         prefix: String?,
         website: String?
    ) {
        self.id = id
        self.createdAt = createdAt
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

