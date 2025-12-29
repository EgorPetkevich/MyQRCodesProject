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
    
}
