//
//  CameraManager.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import AVFoundation
import UIKit

protocol CameraManagerProtocol {
    var onCodeScanned: ((String) -> Void)? { get set }
    var onCameraError: ((String) -> Void)? { get set }
    var qrNotFoundError: ((String) -> Void)? { get set }
    var playLoadAnimation: ((Bool) ->Void)? { get set }
    
    func stopSession()
    func checkPermissionAndStartSession()
    func createPreviewLayer() -> AVCaptureVideoPreviewLayer?
    func toggleTorch(_ isEnabled: Bool, flashMode: ((Bool) -> Void)?)
    func switchCamera()
}

final class CameraManager: NSObject {

    private let session: AVCaptureSession
    private let metadataOutput = AVCaptureMetadataOutput()
    
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    private var currentVideoInput: AVCaptureDeviceInput?
    private let cameraDevice: AVCaptureDevice?

    var sessionQueue: DispatchQueue = .init(label: "com.camera.sessionQueue")
    var accessRequestQueue: DispatchQueue = .init(label: "com.camera.accessRequest")
    
    var onCodeScanned: ((String) -> Void)?
    var onCameraError: ((String) -> Void)?
    var qrNotFoundError: ((String) -> Void)?
    var playLoadAnimation: ((Bool) ->Void)?
    
    init(session: AVCaptureSession = AVCaptureSession()) {
        self.session = session
        self.cameraDevice = AVCaptureDevice.default(for: .video)
        super.init()
    }
    
    func createPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        configureVideoInput()
        configureMetadataOutput()
        return AVCaptureVideoPreviewLayer(session: session)
    }
    
    func checkPermissionAndStartSession() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            startSession()
        case .notDetermined:
            requestCameraAccess()
        default:
            onCameraError?("Camera access denied. Please enable it in Settings.")
        }
    }

    private func requestCameraAccess() {
        accessRequestQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                self?.startSession()
            } else {
                self?.onCameraError?("Camera access denied. Please enable it in Settings.")
            }
            self?.accessRequestQueue.resume()
        }
    }
    
    private func startSession() {
        sessionQueue.async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    private func configureVideoInput() {
        guard let cameraDevice = getCamera(for: currentCameraPosition) else {
            onCameraError?("Camera not available.")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: cameraDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
                currentVideoInput = videoInput
            } else {
                onCameraError?("Unable to add video input.")
            }
        } catch {
            onCameraError?("Error setting up video input: \(error)")
        }
    }
    
    private func configureMetadataOutput() {
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            let availableTypes = metadataOutput.availableMetadataObjectTypes
            if availableTypes.contains(.qr) {
                metadataOutput.metadataObjectTypes = [.qr,
                                                      .ean8,
                                                      .ean13,
                                                      .pdf417,
                                                      .code128]
            }
        } else {
            onCameraError?("Unable to add metadata output.")
        }
    }
    
    func toggleTorch(_ isEnabled: Bool, flashMode: ((Bool) -> Void)?) {
        guard
            let cameraDevice = cameraDevice,
                cameraDevice.hasTorch,
                currentCameraPosition == .back
        else {
            onCameraError?("Flash not available.")
            return
        }
        
        do {
            try cameraDevice.lockForConfiguration()
            cameraDevice.torchMode = isEnabled ? .off : .on
            flashMode?(!isEnabled)
            cameraDevice.unlockForConfiguration()
        } catch {
            onCameraError?("Error toggling flash: \(error)")
        }
    }

    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.session.beginConfiguration()
            
            // Remove current input
            if let currentInput = self.currentVideoInput {
                self.session.removeInput(currentInput)
            }
            
            // Switch position
            self.currentCameraPosition = (self.currentCameraPosition == .back) ? .front : .back
            
            // Add new input
            if let newCamera = self.getCamera(for: self.currentCameraPosition) {
                do {
                    let newInput = try AVCaptureDeviceInput(device: newCamera)
                    if self.session.canAddInput(newInput) {
                        self.session.addInput(newInput)
                        self.currentVideoInput = newInput
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.onCameraError?("Error switching camera: \(error)")
                    }
                }
            }
            
            self.session.commitConfiguration()
        }
    }

    private func getCamera(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: position
        ).devices
        return devices.first
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension CameraManager: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        playLoadAnimation?(true)
        stopSession()
        guard
            let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = metadataObject.stringValue
        else {
            playLoadAnimation?(false)
            qrNotFoundError?("No QR code found.")
            return
        }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        onCodeScanned?(code)
    }
}

extension CameraManager: CameraManagerProtocol { }
