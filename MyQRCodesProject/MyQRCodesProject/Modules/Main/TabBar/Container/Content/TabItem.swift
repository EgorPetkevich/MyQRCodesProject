//
//  TabItem.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 31.12.25.
//

import SwiftUI

enum TabItem: Int {
    case home = 0
    case scan
    case myQrCodes
    case history

    var title: String {
        switch self {
        case .home: return "Home"
        case .scan: return "Scan QR"
        case .myQrCodes: return "My QR Codes"
        case .history: return "History"
        }
    }

    var icon: ImageResource {
        switch self {
        case .home: return .iconHome
        case .scan: return .iconScan
        case .myQrCodes: return .iconFolder
        case .history: return .iconHistory
        }
    }
}
