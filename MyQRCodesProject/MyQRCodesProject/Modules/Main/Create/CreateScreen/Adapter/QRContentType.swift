//
//  QRContentType.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

enum QRContentType: CaseIterable, Identifiable {
    case url
    case text
    case contact
    case wifi

    var id: Self { self }

    var title: String {
        switch self {
        case .url: return "URL"
        case .text: return "Text"
        case .contact: return "Contact"
        case .wifi: return "Wi-Fi"
        }
    }

    var icon: ImageResource {
        switch self {
        case .url: return .createChain
        case .text: return .createLetter
        case .contact: return .createContact
        case .wifi: return .createWifi
        }
    }
}
