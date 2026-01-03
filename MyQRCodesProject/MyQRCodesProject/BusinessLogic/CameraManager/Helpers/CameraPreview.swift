//
//  CameraPreview.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//


import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    let previewLayer: AVCaptureVideoPreviewLayer
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.previewLayer.session = previewLayer.session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {}
}