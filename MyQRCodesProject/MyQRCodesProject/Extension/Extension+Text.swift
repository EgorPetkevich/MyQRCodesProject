//
//  Extension+Text.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 31.12.25.
//

import SwiftUI

extension Text {
    
    func inter(
        size: CGFloat,
        style: InterStyle = .regular,
        color: Color = .appTextPrimary
    ) -> some View {
        self
            .font(.inter(size: size, style: style))
            .foregroundStyle(color)
    }
    
}
