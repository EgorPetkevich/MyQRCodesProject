//
//  HistorySortSection.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//


import SwiftUI

enum HistorySortSection: CaseIterable, Identifiable {
    case all
    case scanned
    case created

    var id: Self { self }

    var title: String {
        switch self {
        case .all:     return "All"
        case .scanned: return "Scanned"
        case .created: return "Created"
        }
    }
}
