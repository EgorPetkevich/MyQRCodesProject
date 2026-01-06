//
//  ScanAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

final class ScanAssembler {
    
    private init() {}
    
    static func make() -> some View {
        let vm = ScanVM(
            cameraManger: CameraManager(),
            qrCodeManager: QrCodeManager()
        )
        
        let vc = ScanVC(viewModel: vm)
        return vc
    }
    
}
