//
//  ProductType.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import Foundation

enum ProductType {
    case weekly
    case monthly
//    case yearly
    
    var decodingName: String {
        switch self {
        case .weekly:
            return "sonicforge_weekly"
        case .monthly:
            return "sonicforge_monthly"
//        case .yearly:
//            return "sonicforge_yearly"
        }
    }
}
