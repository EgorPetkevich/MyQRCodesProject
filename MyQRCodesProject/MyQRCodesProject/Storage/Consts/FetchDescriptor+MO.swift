//
//  FetchDescriptor + SignatureMO.swift
//  ESign
//
//  Created by George Popkich on 5.11.25.
//

import Foundation

extension NSPredicate {
    
    static func byId(_ id: String) -> NSPredicate {
        .init(format: "id == %@", id as CVarArg)
    }
}

extension NSSortDescriptor {
    
    static func byDate() -> NSSortDescriptor {
        .init(key: "createdAt", ascending: false)
    }
    
}
