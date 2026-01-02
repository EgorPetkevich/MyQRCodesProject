//
//  AnalyticsService.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 2.01.26.
//

import AppsFlyerLib

protocol AnalyticsServiceProtocol {
    func track(_ event: AnalyticsEvent)
}

final class AnalyticsService: AnalyticsServiceProtocol {

    static let shared = AnalyticsService()

    private init() {}

    func track(_ event: AnalyticsEvent) {

        // AppsFlyer
        AppsFlyerLib.shared().logEvent(
            event.name,
            withValues: event.parameters
        )
    }
}
