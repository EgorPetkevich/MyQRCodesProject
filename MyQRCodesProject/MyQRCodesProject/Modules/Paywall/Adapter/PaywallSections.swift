//
//  Sections.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 30.12.25.
//

import SwiftUI

enum DescriptionSection: CaseIterable, Hashable, PaywallDescriptionCardProtocol {
    case unlimited
    case create
    case noAds
    case backup
    case analytics
    
    var title: String {
        switch self {
        case .unlimited: return "Unlimited QR Scans"
        case .create: return    "Create All QR Types"
        case .noAds: return     "No Ads"
        case .backup: return    "Cloud Backup"
        case .analytics: return "Cloud Backup"
        }
    }
    
    var subtitle: String {
        switch self {
        case .unlimited: "Scan as many QR codes as you\nwant"
        case .create:    "URL, Text, Contact, WiFi, and\nmore"
        case .noAds:     "Clean, distraction-free\nexperience"
        case .backup:    "Sync across all your devices"
        case .analytics: "Track scans and usage patterns"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .unlimited: .iconInfinity
        case .create:    .iconPalette
        case .noAds:     .iconShield
        case .backup:    .iconCloud
        case .analytics: .iconChart
        }
    }
}
