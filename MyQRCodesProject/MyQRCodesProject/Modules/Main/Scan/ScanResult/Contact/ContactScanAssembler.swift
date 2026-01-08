//
//  ContactScanResultAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import SwiftUI

final class ContactScanResultAssembler {
     
    private init() {}
    
    static func make(dto: ContactDTO, showAds: Bool = false) -> some View {
        let vm = ContactScanResultVM(
            contactDTO: dto,
            showAds: showAds,
            storage: ContactStorage(),
            qrGenerator: DefaultQRCodeGenerator(),
            documentManager: DocumentManager.instance,
            analytics: AnalyticsService(),
            adManagerService: AdManagerService()
        )
        let vc = ContactScanResultVC(viewModel: vm)
        return vc
    }
    
}
