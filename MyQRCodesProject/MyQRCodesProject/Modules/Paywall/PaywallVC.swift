//
//  PaywallVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 30.12.25.
//

import SwiftUI

struct PaywallVC: View {
    
    @StateObject private var vm: PaywallViewModel
    
    init(viewModel: PaywallViewModel) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
    }
}
