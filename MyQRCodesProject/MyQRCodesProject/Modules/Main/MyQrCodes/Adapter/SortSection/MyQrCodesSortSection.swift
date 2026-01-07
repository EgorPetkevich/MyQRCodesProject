//
//  MyQrCodesSortSection.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//

import SwiftUI

enum MyQrCodesSortSection: CaseIterable, Identifiable {
    case all
    case url
    case text
    case wifi
    case contact

    var id: Self { self }

    var title: String {
        switch self {
        case .all: return "All"
        case .url: return "URL"
        case .text: return "Text"
        case .wifi: return "WiFi"
        case .contact: return "Contact"
        }
    }
}
