//
//  CreatedQrPreviewAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

final class CreatedQrPreviewAssembler {
    
    private init() {}
    
    static func make<DTO: DTODescription>(dto: DTO, showAds: Bool = false, designImage: UIImage? = nil) -> some View {
        let vm = CreatedQrPreviewVM(
            dto: dto,
            showAds: showAds,
            designImage: designImage,
            storage: BaseStorage<DTO>(),
            qrGenerator: DefaultQRCodeGenerator(),
            documentManager: DocumentManager.instance,
            analytics: AnalyticsService(),
            adManagerService: AdManagerService()
        )
        let vc = CreatedQrPreviewVC(viewModel: vm)
        return vc
    }
}
