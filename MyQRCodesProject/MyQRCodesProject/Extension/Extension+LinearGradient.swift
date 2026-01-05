//
//  LinearGradient+App.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import Foundation

import SwiftUI

extension LinearGradient {
    
    static let appNextButton = LinearGradient(
        colors: [
            Color(hex: "#7ACBFF"),
            Color(hex: "#4DA6FF")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let appSuccessButton = LinearGradient(
        colors: [
            Color(hex: "#77C97E"),
            Color(hex: "#77C97E")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let appAccentWarning = LinearGradient(
        colors: [
            Color(hex: "#FFB86C"),
            Color(hex: "#FFB86C")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    
    
    static let appOnbBg = LinearGradient(
        colors: [
            .init(hex: "#E8F7FF"),
            .init(hex: "#FFFFFF")
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let paywallOnbBg = LinearGradient(
        colors: [
            .init(hex: "#E8F7FF"),
            .init(hex: "#FFFFFF")
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
}
