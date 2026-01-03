//
//  RoundedRectangleAsBackgroundModifier.swift
//  invoicemaker
//
//  Created by Developer on 4.08.25.
//

import SwiftUI

fileprivate struct RoundedRectangleAsBackgroundModifier: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    let corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangleShape(cornerRadius: cornerRadius, corners: corners)
                    .fill(color)
            )
    }
}

struct RoundedRectangleShape: Shape {
    let cornerRadius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    public func roundedRectangleAsBackground(
        color: Color,
        cornerRadius: CGFloat,
        corners: UIRectCorner = .allCorners
    ) -> some View {
        self.modifier(
            RoundedRectangleAsBackgroundModifier(
                color: color,
                cornerRadius: cornerRadius,
                corners: corners
            )
        )
    }
}
