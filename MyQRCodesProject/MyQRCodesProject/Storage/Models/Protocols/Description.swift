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
  
    func apply(dto: any DTODescription)
    func toDTO() -> (any DTODescription)?
}

protocol DTODescription: Identifiable {
    associatedtype MO: MODescription
    
    var id: String { get set }
    var createdAt: Date { get set }

    func createMO(context: NSManagedObjectContext) -> MO?
}

