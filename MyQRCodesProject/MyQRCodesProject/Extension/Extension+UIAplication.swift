//
//  Extension+UIAplication.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 31.12.25.
//

import UIKit

extension UIApplication {
    
    static func open(strUrl: String) {
        if let url = URL(string: strUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    static func openSettings() {
        if let appSettings =
            URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings,
                                      options: [:],
                                      completionHandler: nil)
        }
    }
    
}
