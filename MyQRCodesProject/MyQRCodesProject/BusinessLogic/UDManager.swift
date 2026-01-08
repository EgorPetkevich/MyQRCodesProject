//
//  UDManager.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import Foundation

final class UDManager {
    
    private static var ud: UserDefaults = .standard
    
    private init() {}
    
    static func set(_ key: AppStorageKeys, value: Bool) {
        ud.set(value, forKey: key.rawValue)
    }
    
    static func get(_ key: AppStorageKeys) -> Bool {
        ud.bool(forKey: key.rawValue)
    }
    
    static func appendResentId(_ id: String) {
        var ids = ud.stringArray(forKey: AppStorageKeys.resentActivityIds.rawValue) ?? []
        
        ids.removeAll { $0 == id }
    
        ids.insert(id, at: 0)
        
        if ids.count > 10 {
            ids = Array(ids.prefix(10))
        }
        
        ud.set(ids, forKey: AppStorageKeys.resentActivityIds.rawValue)
    }
    
    static func getResentIds() -> [String] {
        ud.stringArray(forKey: AppStorageKeys.resentActivityIds.rawValue) ?? []
    }
    
}
