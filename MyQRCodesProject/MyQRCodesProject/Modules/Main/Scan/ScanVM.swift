//
//  ScanVM.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

final class ScanVM: ObservableObject {
    
    @Published var showGoSettingsAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var showLoader: Bool = false
    @Published var flashMode: Bool = false
    
    private var cameraManager: CameraManagerProtocol
    private let qrCodeManager: QrCodeManagerProtocol

    private(set) var previewLayer: AVCaptureVideoPreviewLayer?

    init(cameraManger: CameraManagerProtocol,
         qrCodeManager: QrCodeManagerProtocol) {
        self.cameraManager = cameraManger
        self.qrCodeManager = qrCodeManager
        setupCameraManager()
        setupPreview()
    }

    private func setupPreview() {
        previewLayer = cameraManager.createPreviewLayer()
    }
    
    @objc func viewWillResignActive() {
        cameraManager.toggleTorch(true) { [weak self] flashMode in
            DispatchQueue.main.async {
                self?.flashMode = flashMode
            }
        }
        stopScanning()
      }
    
    
    private func setupCameraManager() {
        cameraManager.onCodeScanned = { [weak self] code in
                self?.processScannedCode(code)
        }
        cameraManager.onCameraError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showGoSettingsAlert = true
            }
        }
        cameraManager.playLoadAnimation = { [weak self] value in
            DispatchQueue.main.async {
                self?.showLoader = true
            }
        }
        cameraManager.qrNotFoundError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert = true
            }
        }
    }
    
    func startScanning() {
        cameraManager.checkPermissionAndStartSession()
    }
    
    func stopScanning() {
        cameraManager.stopSession()
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return cameraManager.createPreviewLayer()
    }
    
    func toggleFlash() {
        cameraManager.toggleTorch(flashMode) { [weak self] flashMode in
            DispatchQueue.main.async {
                self?.flashMode = flashMode
            }
        }
    }
    
    func switchCamera() {
        cameraManager.switchCamera()
    }
    
    private func processScannedCode(_ code: String) {
        qrCodeManager.getQRCodeData(code) { [weak self] result in
            DispatchQueue.main.async {
                self?.showLoader = false
            }
            switch result {
            case .success(let model):
                //FIXME: Save model
               print(model)
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showErrorAlert = true
                }
            }
        }
    }
    
    func processImageQRCode(_ image: UIImage) {
        showLoader = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let ciImage = CIImage(image: image) else {
                DispatchQueue.main.async {
                    self?.showLoader = false
                    self?.showErrorAlert = true
                }
                return
            }
            
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            let features = detector?.features(in: ciImage) as? [CIQRCodeFeature] ?? []
            
            if let code = features.first?.messageString {
                DispatchQueue.main.async {
                    self?.showLoader = false
                    self?.processScannedCode(code)
                }
            } else {
                DispatchQueue.main.async {
                    self?.showLoader = false
                    self?.showErrorAlert = true
                }
            }
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

}
