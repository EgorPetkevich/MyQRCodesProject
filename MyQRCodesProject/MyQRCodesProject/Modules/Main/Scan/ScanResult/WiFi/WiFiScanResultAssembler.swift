//
//  WiFiScanResultAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import SwiftUI

final class WiFiScanResultAssembler {
    
    private init() {}
    
    static func make(dto: WiFiDTO, showAds: Bool = false) -> some View {
        let vm = WiFiScanResultVM(
            wifiDTO: dto,
            showAds: showAds,
            storage: WiFiStorage(),
            qrGenerator: DefaultQRCodeGenerator(),
            documentManager: DocumentManager.instance,
            analytics: AnalyticsService(),
            adManagerService: AdManagerService()
        )
        let vc = WiFiScanResultVC(viewModel: vm)
        return vc
    }
    
}
