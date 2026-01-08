//
//  CreateAssembler.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

final class CreateAssembler {
    
    private init() {}
    
    static func make(apphudService: ApphudService) -> some View {
        let vm = CreateVM(apphudService: apphudService)
        let vc = CreateVC(viewModel: vm)
        return vc
    }
    
}
