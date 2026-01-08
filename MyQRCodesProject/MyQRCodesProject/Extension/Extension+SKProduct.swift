//
//  Extension+SKProduct.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import Foundation
import StoreKit

extension SKProduct {
    
    var formattedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
    
}
