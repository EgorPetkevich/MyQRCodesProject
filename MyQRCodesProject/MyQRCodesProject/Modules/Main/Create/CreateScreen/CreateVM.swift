//
//  CreateVM.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import Foundation
import Combine

final class CreateVM: ObservableObject {

    @Published var selectedType: QRContentType = .url
    @Published var showResult: Bool = false
    @Published var createdDTO: (any DTODescription)?
    
    // URL
    @Published var urlText: String = ""

    // Text
    @Published var plainText: String = ""

    // Contact
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""

    // WiFi
    @Published var ssid: String = ""
    @Published var password: String = ""
    @Published var isHidden: Bool = false
    @Published var wifiSecurity: WiFiSecurity = .open

    // Errors
    @Published var errorLink: String?
    @Published var errorText: String?
    @Published var errorContact: String?
    @Published var errorWifi: String?
    
    private var bag: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        $createdDTO
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dto in
                guard let _ = dto else { return }
                self?.showResult = true
            }
            .store(in: &bag)
    }
    

    func generateButtonDidTap() {
        clearErrors()

        switch selectedType {
        case .url:     generateLinkQrCode()
        case .text:    generateTextQrCode()
        case .contact: generateContactQrCode()
        case .wifi:    generateWifiQrCode()
        }
    }

    private func clearErrors() {
        errorLink = nil
        errorText = nil
        errorContact = nil
        errorWifi = nil
    }

    private func generateLinkQrCode() {
        let urlTextTrimmed = urlText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            !urlTextTrimmed.isEmpty,
            let _ = URL(string: urlTextTrimmed)
        else {
            errorLink = "Please enter a URL"
            return
        }
        let linkDTO = LinkDTO(
            id: UUID().uuidString,
            link: urlTextTrimmed,
            createdAt: .now
        )
        
        createdDTO = linkDTO
    }

    private func generateTextQrCode() {
        guard
            !plainText
                .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            errorText = "Text cannot be empty"
            return
        }
        let TextDTO = TextDTO(
            id: UUID().uuidString,
            text: plainText,
            createdAt: .now
        )
        createdDTO = TextDTO
    }

    private func generateContactQrCode() {
        let firstNameTrimmed = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastNameTrimmed = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneTrimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailTrimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let hasAny =
        !firstNameTrimmed.isEmpty ||
        !lastNameTrimmed.isEmpty ||
        !phoneTrimmed.isEmpty ||
        !emailTrimmed.isEmpty

        guard hasAny else {
            errorContact = "Enter at least one contact field"
            return
        }
        let contactDTO = ContactDTO(
            id: UUID().uuidString,
            createdAt: .now,
            email: emailTrimmed,
            firstName: firstNameTrimmed,
            lastName: lastNameTrimmed,
            phoneNumber: phoneTrimmed
        )
        
        createdDTO = contactDTO
    }

    private func generateWifiQrCode() {
        guard !ssid.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorWifi = "SSID is required"
            return
        }
        let wifiDTO = WiFiDTO(
            id: UUID().uuidString,
            createdAt: .now,
            ssid: ssid,
            isHidden: isHidden,
            password: password,
            security: wifiSecurity.rawValue
        )
        createdDTO = wifiDTO
    }
    
}
