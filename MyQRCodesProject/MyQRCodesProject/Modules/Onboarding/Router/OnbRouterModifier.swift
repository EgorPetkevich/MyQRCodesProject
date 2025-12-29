//
//  OnbRouterModifier.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

struct OnbRouterModifier: ViewModifier {
    
    @State private var router: OnbRouter
    
    init(router: OnbRouter) {
        self.router = router
    }
    
    func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environment(router)
                .navigationDestination(for: OnbPath.self) { route in
                    routeView(for: route)
                }
        }
    }
    
    private func routeView(for route: OnbPath) -> some View {
        Group {
            switch route {
            case .first:  OnbFirstScreenVC()
            case .second: OnbSecondScreenVC()
            case .third:  OnbThirdScreenVC()
            case .fourth: OnbFourthScreenVC()
            }
        }
        .environment(router)
    }
    
}
