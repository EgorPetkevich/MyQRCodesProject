//
//  AppStorage+Keys.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

enum AppStorageKeys: String {
    case onboardingPassed
    case createQrCodeImagesDirectory
    
    case resentActivityIds
}

extension AppStorage where Value == Bool {
    
    init(
        wrappedValue: Bool,
        _ key: AppStorageKeys,
        store: UserDefaults? = nil
    ) {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
}

extension AppStorage where Value == String {
    
    init(
        wrappedValue: String,
        _ key: AppStorageKeys,
        store: UserDefaults? = nil
    ) {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
}
