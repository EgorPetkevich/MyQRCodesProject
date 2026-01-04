//
//  LinkScanResultVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import SwiftUI

struct LinkScanResultVC: View {
    
    private enum Const {
        static let title: String = "Scan Result"
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm: LinkScanResultVM

    
    init(viewModel: LinkScanResultVM) {
        self._vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            
        
        }
        
    }
    
    private var header: some View {
        VStack {
            Spacer()
            HStack {
                Text(Const.title)
                    .inter(size: 22, style: .semiBold)
                    .padding(.bottom, 16)
                Spacer()
                
                Button(action: { dismiss() }) {
                    ZStack {
                        Circle()
                            .fill(.appTextBorder)
                            .frame(width: 40, height: 40)
                        Image(.resultCross)
                            .size(9)
                    }
                }
            }
            .padding(.horizontal, 24)
            
        }
        .frame(height: 100)
        .background(Color.appPrimaryBg)
    }
    
}
