//
//  Description.swift
//  DataStorage
//
//  Created by George Popkich on 28.11.24.
//

import Foundation
import CoreData

protocol MODescription: NSManagedObject, NSFetchRequestResult {
    var id: String? { get }
    var createdAt: Date? { get }
    var scanned: Bool { get }
  
    func apply(dto: any DTODescription)
    func toDTO() -> (any DTODescription)?
}

protocol DTODescription: Identifiable {
    associatedtype MO: MODescription
    
    var id: String { get set }
    var createdAt: Date { get set }
    var scanned: Bool { get set }
    var qrPayload: String { get }

    func createMO(context: NSManagedObjectContext) -> MO?
}

