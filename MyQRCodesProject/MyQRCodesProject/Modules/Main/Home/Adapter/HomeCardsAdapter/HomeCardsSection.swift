//
//  HomeCardsSectoin.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

enum HomeCardsSection: Hashable, CaseIterable, HomeCardProtocol {

    case scan
    case create
    case myCodes
    case history
    
    var icon: ImageResource {
        switch self {
        case .scan: .homeScan
        case .create: .homePlus
        case .myCodes: .homeFolder
        case .history: .homeHistory
        }
    }
    
    var bgIconColor: ColorResource {
        switch self {
        case .scan:    .appAccentPrimary
        case .create:  .appAccentSuccess
        case .myCodes: .appAccentWarning
        case .history: .appTextDisabled
        }
    }
    
    var title: String {
        switch self {
        case .scan:    "Scan QR"
        case .create:  "Create QR"
        case .myCodes: "My QR\nCodes"
        case .history: "History"
        }
    }
    
    var subtitle: String {
        switch self {
        case .scan:    "Quick scan"
        case .create:  "Generate new"
        case .myCodes: " Saved codes"
        case .history: "Recent scans"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .scan:    177.0
        case .create:  177.0
        case .myCodes: 202.5
        case .history: 202.5
        }
    }
    
    
}
