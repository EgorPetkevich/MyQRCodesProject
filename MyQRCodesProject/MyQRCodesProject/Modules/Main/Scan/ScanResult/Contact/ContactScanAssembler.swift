//
//  ContactScanResultAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import SwiftUI

final class ContactScanResultAssembler {
     
    private init() {}
    
    static func make(dto: ContactDTO) -> some View {
        let vm = ContactScanResultVM(
            contactDTO: dto,
            storage: ContactStorage(),
            qrGenerator: DefaultQRCodeGenerator(),
            documentManager: DocumentManager.instance
        )
        let vc = ContactScanResultVC(viewModel: vm)
        return vc
    }
    
}
