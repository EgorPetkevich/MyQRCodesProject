//
//  View+Router.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

extension View {
    
    func withRouter(_ router: OnbRouter) -> some View {
        modifier(OnbRouterModifier(router: router))
    }
    
    func setShadow(
        with radius: CGFloat,
        color: Color = .black.opacity(0.06)
    ) -> some View {
        self.shadow(
            color: color,
            radius: radius,
            x: 0,
            y: 4
        )
    }
    
}

