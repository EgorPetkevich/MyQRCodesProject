//
//  SuccessfulScanView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import SwiftUI

struct SuccessfulScanView: View {
    
    var body: some View {
        VStack {
            Image(.iconAdd)
                .scaledToFit()
                .background(
                    Circle()
                        .fill(.appAccentSuccess)
                        .frame(width: 80, height: 80)
                        .setShadow(with: 24, color: .appAccentSuccess)
                )
            
        }
    }
    
}
