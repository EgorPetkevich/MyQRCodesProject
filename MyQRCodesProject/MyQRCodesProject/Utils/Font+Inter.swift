//
//  Font+Inter.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

extension Font {
    static func inter(size: CGFloat, style: InterStyle) -> Font {
        .custom(style.postScriptName, size: size)
    }
}
