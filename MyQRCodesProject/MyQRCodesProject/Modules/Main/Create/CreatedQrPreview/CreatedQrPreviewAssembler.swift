//
//  CreatedQrPreviewAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

final class CreatedQrPreviewAssembler {
    
    private init() {}
    
    static func make<DTO: DTODescription>(dto: DTO) -> some View {
        let vm = CreatedQrPreviewVM(
            dto: dto,
            storage: BaseStorage<DTO>(),
            qrGenerator: DefaultQRCodeGenerator(),
            documentManager: DocumentManager.instance
        )
        let vc = CreatedQrPreviewVC(viewModel: vm)
        return vc
    }
}
