//
//  LinkScanResultAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import SwiftUI

final class LinkScanResultAssembler {
    
    private init() {}
    
    static func make(dto: LinkDTO) -> some View {
        let vm = LinkScanResultVM(
            linkDTO: dto,
            storage: LinkStorage()
        )
        let vc = LinkScanResultVC(viewModel: vm)
        return vc
    }
    
}
