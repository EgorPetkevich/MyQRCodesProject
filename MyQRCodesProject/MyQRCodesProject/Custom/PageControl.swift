//
//  PageControl.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

struct PageControl: View {
    
    private enum Const {
        static let dotSize: CGFloat = 8
        static let spacing: CGFloat = 8
        static let selectedDotWidht: CGFloat = 32
    }
    
    let currentPage: Int
    
    let pageCount: Int = 4
    private let selectedDotColor: Color = .appAccentPrimary
    private let unselectedDotColor: Color = .init(hex: "#E5E7EB")
    
    var body: some View {
        HStack(spacing: Const.spacing) {
            ForEach(0..<pageCount, id: \.self) { point in
                if point == currentPage {
                    RoundedRectangle(cornerRadius: Const.dotSize / 2)
                        .fill(selectedDotColor)
                        .frame(
                            width: Const.selectedDotWidht,
                            height: Const.dotSize
                        )
                } else {
                    Circle()
                        .fill(unselectedDotColor)
                        .frame(
                            width: Const.dotSize,
                            height: Const.dotSize
                        )
                }
            }
        }
        .frame(height: Const.dotSize)
    }
    
}
