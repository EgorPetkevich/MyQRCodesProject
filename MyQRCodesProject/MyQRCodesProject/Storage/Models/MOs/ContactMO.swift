//
//  ContactMO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//


import Foundation

extension ContactMO: MODescription {
    
    func apply(dto: any DTODescription) {
        guard let contactDTO = dto as? ContactDTO else {
            print("[MODTO]", "\(Self.self) apply failsed: dto is type of \(Swift.type(of: dto))")
            return
        }
        self.id = contactDTO.id
        self.createdAt = contactDTO.createdAt
        self.scanned = contactDTO.scanned
        self.address = contactDTO.address
        self.birthday = contactDTO.birthday
        self.email = contactDTO.email
        self.firstName = contactDTO.firstName
        self.lastName = contactDTO.lastName
        self.jobTitle = contactDTO.jobTitle
        self.organization = contactDTO.organization
        self.phoneNumber = contactDTO.phoneNumber
        self.phoneNumberWork = contactDTO.phoneNumberWork
        self.prefix = contactDTO.prefix
        self.website = contactDTO.website
    }
    
    func toDTO() -> (any DTODescription)? {
        ContactDTO(mo: self)
    }
    
    
}
