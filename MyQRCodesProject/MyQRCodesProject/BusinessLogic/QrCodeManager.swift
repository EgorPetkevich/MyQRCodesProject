//
//  QrCodeManager.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import Foundation
import UIKit

struct QrCodeModel {
    var id: String
    var date: Date
    var name: String
}

protocol QrCodeManagerProtocol {
    typealias ResultHandler = (Result<QrCodeModel, Error>) -> Void
    
    func getQRCodeData(_ str: String, completion: @escaping ResultHandler)
}

final class QrCodeManager {
    
    typealias ResultHandler = (Result<QrCodeModel, Error>) -> Void
    
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
        
        if let phone = textProcessor.detectPhone(in: str) {
            handlePhoneDetection(phone, originalString: str, completion: completion)
            return
        }
        
        if let geo = textProcessor.detectGeolocation(in: str) {
            handleGeoDetection(geo: geo, originalString: str, completion: completion)
        }
        
        if let mail = textProcessor.detectMail(in: str) {
            handleMailDetection(mail, originalString: str, completion: completion)
            return
        }
        
        if let url = textProcessor.detectURL(in: str) {
            handleURLDetection(url, originalString: str, completion: completion)
            return
        }
        
        handleTextDetection(str, completion: completion)
    }
    
    private func handleGeoDetection(
        geo: String,
        originalString: String,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        let link = textProcessor.detectURL(in: originalString)
//        let geoTModel = GeoTransferModel(
//            date: .now,
//            id: id,
//            name: originalString,
//            geo: geo,
//            link: link?.relativeString
//        )
//        completion(.success(geoTModel))
    }
    
    private func handlePhoneDetection(
        _ phone: String,
        originalString: String,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        
//        let phoneTModel = PhoneTransferModel(
//            date: .now,
//            id: id,
//            name: originalString,
//            phone: phone
//        )
//        completion(.success(phoneTModel))
    }
    
    private func handleURLDetection(
        _ url: URL,
        originalString: String,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        
//        let linkTModel = LinkTransferModel(
//            date: .now,
//            id: id,
//            name: originalString,
//            link: originalString
//        )
//        DispatchQueue.main.async {
//            completion(.success(linkTModel))
//        }
        
    }
    
    private func handleTextDetection(
        _ text: String,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        
//        let textTModel = TextTransferModel(
//            date: .now,
//            id: id,
//            name: text,
//            text: text
//        )
//        completion(.success(textTModel))
    }
    
    private func handleMailDetection(
        _ email: String,
        originalString: String,
        completion: @escaping ResultHandler
    ) {
        let id = UUID().uuidString
        
//        let mailTModel = EmailTransferModel(
//            date: .now,
//            id: id,
//            name: originalString,
//            email: email
//        )
//        completion(.success(mailTModel))
    }
                       
}

extension QrCodeManager: QrCodeManagerProtocol {}
