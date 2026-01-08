//
//  LinkScanResultAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import SwiftUI

final class LinkScanResultAssembler {
    
    private init() {}
    
    static func make(dto: LinkDTO, showAds: Bool = false) -> some View {
        let vm = LinkScanResultVM(
            linkDTO: dto,
            showAds: showAds,
            storage: LinkStorage(),
            qrGenerator: DefaultQRCodeGenerator(),
            documentManager: DocumentManager.instance,
            analytics: AnalyticsService(),
            adManagerService: AdManagerService()
        )
        let vc = LinkScanResultVC(viewModel: vm)
        return vc
    }
    
}
