//
//  OnbRouter.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import Foundation

final class OnbRouter: AppRouter {
    
    func openFirst() {
        path.append(OnbPath.first)
    }
    
    func openSecond() {
        path.append(OnbPath.second)
    }
    
    func openThird() {
        path.append(OnbPath.third)
    }
    
    func openFourth() {
        path.append(OnbPath.fourth)
    }
    
}
