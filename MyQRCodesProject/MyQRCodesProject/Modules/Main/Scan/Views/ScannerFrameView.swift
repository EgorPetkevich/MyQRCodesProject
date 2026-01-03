//
//  ScannerFrameView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

enum ScannerLayout {
    static let frameSize: CGFloat = 280
    static let cornerRadius: CGFloat = 24
}

struct ScannerFrameView: View {

    var body: some View {
        RoundedRectangle(cornerRadius: ScannerLayout.cornerRadius)
            .stroke(Color.appAccentPrimary, lineWidth: 2)
            .frame(
                width: ScannerLayout.frameSize,
                height: ScannerLayout.frameSize
            )
    }
}

