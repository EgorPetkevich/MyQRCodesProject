//
//  AppDelegate.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 2.01.26.
//

import UIKit
import AppsFlyerLib
import AppTrackingTransparency
import AppMetricaCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        TrackingService.shared.setup()
        
        // SceneDelegate support
        NotificationCenter.default
            .addObserver(
                self,
                selector: NSSelectorFromString("didBecomeActiveNotification"),
                name: UIApplication.didBecomeActiveNotification,
                object: nil
            )
        
        return true
    }
    
    // SceneDelegate support
    @objc func didBecomeActiveNotification() {
        TrackingService.shared.requestATTAndStart()
        MobileAds.shared.start()
        if let reporterConfiguration = MutableReporterConfiguration(apiKey: Constants.appMetricaKey) {
            reporterConfiguration.areLogsEnabled = true
            AppMetrica.activateReporter(with: reporterConfiguration)
        }
    }
    
}
