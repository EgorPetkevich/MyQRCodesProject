//
//  MyQrCodesAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//

import SwiftUI

final class MyQrCodesAssembler {
    
    private init() {}
    
    static func make() -> some View {
        let vm = MyQrCodesVM(storage: QRCodesFetchService(),
                             qrGenerator: DefaultQRCodeGenerator())
        let vc = MyQrCodesVC(viewModel: vm)
        return vc
    }
    
}
