//
//  AppRouter.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class AppRouter {
    
    var path = NavigationPath()
    
    func pop() { path.removeLast() }
    
    func popToRoot() { path.removeLast(path.count) }
    
}
