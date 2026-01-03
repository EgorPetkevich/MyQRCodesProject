//
//  CameraPreviewView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI
import AVFoundation

final class CameraPreviewView: UIView {
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}
