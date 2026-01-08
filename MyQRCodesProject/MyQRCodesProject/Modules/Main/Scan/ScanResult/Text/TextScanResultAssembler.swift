//
//  TextScanResultAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import SwiftUI

final class TextScanResultAssembler {
    
    private init() {}
    
    static func make(dto: TextDTO, showAds: Bool = false) -> some View {
        let vm = TextScanResultVM(
            textDTO: dto,
            showAds: showAds,
            storage: TextStorage(),
            qrGenerator: DefaultQRCodeGenerator(),
            documentManager: DocumentManager.instance,
            analytics: AnalyticsService(),
            adManagerService: AdManagerService()
        )
        let vc = TextScanResultVC(viewModel: vm)
        return vc
    }
    
}
