//
//  HomeAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//


import SwiftUI

final class HomeAssembler {
    
    private init() {}
    
    static func make() -> some View {
        let vm = HomeVM(storage: QRCodesFetchService())
        let vc = HomeVC(viewModel: vm)
        return vc
    }
    
}
