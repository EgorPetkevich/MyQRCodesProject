//
//  Font+AppFont.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

extension Font {
    static func app(_ style: AppTextStyle) -> Font {
        switch style {
        case .largeTitle: return .inter(size: 34, style: .bold)
        case .title1:     return .inter(size: 28, style: .bold)
        case .title2:     return .inter(size: 22, style: .semiBold)
        case .body:       return .inter(size: 17, style: .regular)
        case .caption:    return .inter(size: 15, style: .regular)
        case .button:     return .inter(size: 17, style: .semiBold)
        case .tabBar:     return .inter(size: 10, style: .medium)
        }
    }
}

extension Font {
    static func inter(size: CGFloat, style: InterStyle) -> Font {
        .custom(style.postScriptName, size: size)
    }
}

