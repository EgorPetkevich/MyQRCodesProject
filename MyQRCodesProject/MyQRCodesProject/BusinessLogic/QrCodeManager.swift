//
//  QrCodeManager.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import Foundation
import UIKit

protocol QrCodeManagerProtocol {
    typealias ResultHandler = (Result<any DTODescription, Error>) -> Void
    
    func getQRCodeData(_ str: String, completion: @escaping ResultHandler)
}

final class QrCodeManager {
    
    typealias ResultHandler = (Result<any DTODescription, Error>) -> Void
    
    // MARK: - Errors
    enum QrCodeManagerError: Error {
        case invalidInput
    }
    
    private let textProcessor: TextProcessingProtocol
    
    init(
        textProcessor: TextProcessingProtocol = DefaultTextProcessor()
    ) {

        self.textProcessor = textProcessor
    }
    
    func getQRCodeData(_ str: String, completion: @escaping ResultHandler) {
        guard !str.isEmpty else {
            completion(.failure(QrCodeManagerError.invalidInput))
            return
        }
        
        if let vCard = textProcessor.detectVCard(in: str) {
            handleVCardDetection(vCard, completion: completion)
            return
        }
        
        if let url = textProcessor.detectURL(in: str) {
            handleURLDetection(url, originalString: str, completion: completion)
            return
        }
        
        if let wifi = textProcessor.detectWiFi(in: str) {
            handleWiFiDetection(wifi, completion: completion)
            return
        }
        
        handleTextDetection(str, completion: completion)
    }
    
    private func handleWiFiDetection(
        _ wifi: WiFiNetwork,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        let wifiDTO = WiFiDTO(
            id: id,
            createdAt: .now,
            ssid: wifi.ssid,
            isHidden: wifi.isHidden,
            password: wifi.password,
            security: wifi.security
        )
        completion(.success(wifiDTO))
    }
    
    private func handleVCardDetection(
        _ vCard: VCard,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        let contactDTO = ContactDTO(
            id: id,
            createdAt: .now,
            address: vCard.address,
            birthday: vCard.birthday,
            email: vCard.email,
            firstName: vCard.firstName,
            lastName: vCard.lastName,
            jobTitle: vCard.jobTitle,
            organization: vCard.organization,
            phoneNumber: vCard.phoneNumber,
            phoneNumberWork: vCard.phoneNumberWork,
            prefix: vCard.prefix,
            website: vCard.website
        )
        completion(.success(contactDTO))
    }
    
    private func handleURLDetection(
        _ url: URL,
        originalString: String,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        let linkDTO = LinkDTO(
            id: id,
            link: originalString,
            createdAt: .now
        )
        completion(.success(linkDTO))
    }
    
    private func handleTextDetection(
        _ text: String,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        let textDTO = TextDTO(
            id: id,
            text: text,
            createdAt: .now
        )
        completion(.success(textDTO))
    }
    
                       
}

extension QrCodeManager: QrCodeManagerProtocol {}
