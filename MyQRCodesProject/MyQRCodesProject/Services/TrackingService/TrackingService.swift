//
//  TrackingService.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 2.01.26.
//

import Foundation
import AppsFlyerLib
import AppTrackingTransparency
import ApphudSDK

final class TrackingService: NSObject, AppsFlyerLibDelegate {

    static let shared = TrackingService()
    
    private let lib = AppsFlyerLib.shared()
    private let analyticsService: AnalyticsServiceProtocol
    
    private override init() {
        self.analyticsService = AnalyticsService.shared
        super.init()
        lib.delegate = self
    }
    
    // MARK: - Setup AppsFlyer
    func setup() {
        lib.appsFlyerDevKey = Constants.appFlyerDevKey
        lib.appleAppID = Constants.appId
        
        lib.isDebug = true // to see AppsFlyer debug logs
    }
    
    // MARK: - ATT and launch AppsFlyer
    func requestATTAndStart() {
        lib.waitForATTUserAuthorization(timeoutInterval: 60)
        
        ATTrackingManager.requestTrackingAuthorization { status in
            let attStatus: String
            switch status {
            case .denied: attStatus = "denied"
            case .notDetermined: attStatus = "notDetermined"
            case .restricted: attStatus = "restricted"
            case .authorized: attStatus = "authorized"
            @unknown default: attStatus = "unknown"
            }
            
            print("ATT status:", attStatus)
            
            // log event
            self.analyticsService.track(.attStatusChanged(status: attStatus))
            
            self.startAppsFlyer()
        }
    }
    
    // MARK: - Start AppsFlyer
    private func startAppsFlyer() {
        lib.start()
    }
    
    // MARK: - AppsFlyer Delegate (Conversion Callback)
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        let apphudData = ApphudAttributionData(rawData: conversionInfo)
        let appFlyerUID = lib.getAppsFlyerUID()
        
        Apphud.setAttribution(
            data: apphudData,
            from: .appsFlyer,
            identifer: appFlyerUID,
            callback: { success in
                print("Apphud attribution success:", success)
            }
        )
    }
    
    func onConversionDataFail(_ error: Error) {
        let apphudData = ApphudAttributionData(rawData: ["error": error.localizedDescription])
        let appFlyerUID = lib.getAppsFlyerUID()
        
        Apphud.setAttribution(
            data: apphudData,
            from: .appsFlyer,
            identifer: appFlyerUID,
            callback: { _ in }
        )
    }
}

