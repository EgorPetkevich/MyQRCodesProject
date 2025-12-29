//
//  InterStyle.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import Foundation

enum InterStyle {
    case regular, thin, extraLight, light, medium, semiBold, bold, extraBold, black

    var postScriptName: String {
        switch self {
        case .regular:    return "Inter-Regular"
        case .thin:       return "Inter-Regular_Thin"
        case .extraLight: return "Inter-Regular_ExtraLight"
        case .light:      return "Inter-Regular_Light"
        case .medium:     return "Inter-Regular_Medium"
        case .semiBold:   return "Inter-Regular_SemiBold"
        case .bold:       return "Inter-Regular_Bold"
        case .extraBold:  return "Inter-Regular_ExtraBold"
        case .black:      return "Inter-Regular_Black"
        }
    }
}
