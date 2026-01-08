//
//  WiFiScanResultVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import UIKit
import Combine
import NetworkExtension
import CoreLocation

final class WiFiScanResultVM: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var showCopiedToast = false
    @Published var showSavedToast = false
    @Published var showConnectErrorAlert = false
    @Published var connectErrorMessage: String?
    @Published var showShareSheet = false
    @Published var shareItems: [Any] = []
    
    private let locationManager = CLLocationManager()

    let wifiDTO: WiFiDTO
    private let storage: WiFiStorage
    
    private let qrGenerator: QRCodeGeneratorProtocol
    private let documentManager: DocumentManagerProtocol

    private var bag = Set<AnyCancellable>()

    init(
        wifiDTO: WiFiDTO,
        storage: WiFiStorage,
        qrGenerator: QRCodeGeneratorProtocol,
        documentManager: DocumentManagerProtocol
    ) {
        self.wifiDTO = wifiDTO
        self.storage = storage
        self.qrGenerator = qrGenerator
        self.documentManager = documentManager
        super.init()
        locationManager.delegate = self
        requestLocationPermissionIfNeeded()
    }
    
//    func actionButtonDidTap() {
//        // Просто перекидываем в Wi-Fi настройки
//        if let url = URL(string: "App-Prefs:root=WIFI") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            } else {
//                connectErrorMessage = "Cannot open Wi-Fi settings on this device."
//                showConnectErrorAlert = true
//            }
//        }
//    }

    func actionButtonDidTap() {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
              CLLocationManager.authorizationStatus() == .authorizedAlways else {
            connectErrorMessage = "Location permission required to connect to Wi-Fi."
            showConnectErrorAlert = true
            return
        }

        guard wifiDTO.canConnect else {
            connectErrorMessage = "Cannot connect to this Wi-Fi."
            showConnectErrorAlert = true
            return
        }

        let manager = NEHotspotConfigurationManager.shared
        manager.removeConfiguration(forSSID: wifiDTO.ssid)

        let configuration: NEHotspotConfiguration
        if let password = wifiDTO.password {
            configuration = NEHotspotConfiguration(
                ssid: wifiDTO.ssid,
                passphrase: password,
                isWEP: wifiDTO.isWEP
            )
        } else {
            configuration = NEHotspotConfiguration(ssid: wifiDTO.ssid)
        }

        configuration.hidden = wifiDTO.isHidden
        configuration.joinOnce = true

        manager.apply(configuration) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    switch error.code {
                    case NEHotspotConfigurationError.alreadyAssociated.rawValue:
                        self?.connectErrorMessage = "Already connected to this network."
                    case NEHotspotConfigurationError.userDenied.rawValue:
                        self?.connectErrorMessage = "User denied connection."
                    case NEHotspotConfigurationError.invalid.rawValue:
                        self?.connectErrorMessage = "Invalid Wi-Fi configuration."
                    default:
                        self?.connectErrorMessage = "Wi-Fi connection failed. \(error.localizedDescription)"
                    }
                    self?.showConnectErrorAlert = true
                }
            }
        }
    }
    
    // MARK: - SAVE

    func saveButtonDidTap() {
        storage.save(dto: wifiDTO)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("[Storage]: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] in
                    guard let self else { return }
                    
//                    self.generateQrAndSave()
                    UDManager.appendResentId(wifiDTO.id)
                    self.showSavedToast = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showSavedToast = false
                    }
                    
                }
            )
            .store(in: &bag)
    }
    
    private func generateQrAndSave() {
        guard let qrImage = qrGenerator.generate(from: wifiDTO.qrPayload) else {
            print("[QR]: Failed to generate image")
            return
        }

        documentManager.saveQr(image: qrImage, with: wifiDTO.id)
    }

    // MARK: - COPY

    func copyButtonDidTap() {
        UIPasteboard.general.string = wifiDTO.ssid
        showCopiedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showCopiedToast = false
        }
    }

    // MARK: - SHARE (WiFi QR / text)

    func shareDidTap() {
        let text = """
        Wi-Fi Network
        SSID: \(wifiDTO.ssid)
        Security: \(wifiDTO.securityDisplayName)
        Password: \(wifiDTO.password ?? "—")
        """

        shareItems = [text]
        showShareSheet = !shareItems.isEmpty
    }
    
    func requestLocationPermissionIfNeeded() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            connectErrorMessage = "Location permission required to connect to Wi-Fi."
            showConnectErrorAlert = true
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            // теперь можно вызывать apply(configuration)
        }
    }
}

