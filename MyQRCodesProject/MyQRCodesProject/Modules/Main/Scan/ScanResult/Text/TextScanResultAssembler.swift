//
//  TextScanResultAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import SwiftUI

final class TextScanResultAssembler {
    
    private init() {}
    
    static func make(dto: TextDTO) -> some View {
        let vm = TextScanResultVM(
            textDTO: dto,
            storage: TextStorage(),
            qrGenerator: DefaultQRCodeGenerator(),
            documentManager: DocumentManager.instance
        )
        let vc = TextScanResultVC(viewModel: vm)
        return vc
    }
    
}
