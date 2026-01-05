//
//  WiFiScanResultAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import SwiftUI

final class WiFiScanResultAssembler {
    
    private init() {}
    
    static func make(dto: WiFiDTO) -> some View {
        let vm = WiFiScanResultVM(
            wifiDTO: dto,
            storage: WiFiStorage()
        )
        let vc = WiFiScanResultVC(viewModel: vm)
        return vc
    }
    
}
