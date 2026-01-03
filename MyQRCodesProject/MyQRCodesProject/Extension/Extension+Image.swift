//
//  Extension+Image.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

extension Image {
    
    func size(_ size: CGFloat) -> some View {
        resizable().scaledToFit().frame(width: size, height: size)
    }
    
}
