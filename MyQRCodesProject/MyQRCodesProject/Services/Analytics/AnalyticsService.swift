//
//  AnalyticsService.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import Foundation
import AppMetricaCore
import AppsFlyerLib

protocol AnalyticsServiceProtocol {
    func track(_ event: AnalyticsEvent)
}

final class AnalyticsService: AnalyticsServiceProtocol {
    
    static let shared = AnalyticsService()

    func track(_ event: AnalyticsEvent) {

        // AppMetrica
        guard let reporter = AppMetrica.reporter(for: Constants.appMetricaKey) else {
            print("REPORT ERROR: Failed to create AppMetrica reporter")
            return
        }
        reporter.resumeSession()
        reporter.reportEvent(
            name: event.name,
            parameters: event.parameters
        )
        
        // AppsFlyerLib
        AppsFlyerLib.shared().logEvent(event.name, withValues: event.parameters)
    }
}
