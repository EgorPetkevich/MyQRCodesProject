//
//  HistoryAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import SwiftUI

final class HistoryAssembler {
    
    private init() {}
    
    static func make() -> some View {
        let vm = HistoryVM(storage: QRCodesFetchService(),
                           qrGenerator: DefaultQRCodeGenerator())
        let vc = HistoryVC(viewModel: vm)
        return vc
    }
    
}
