//
//  DocumentManager.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import UIKit

protocol DocumentManagerProtocol {
    func readQr(with id: String) -> UIImage?
    func readBg(with id: String) -> UIImage?
    func saveQr(image: UIImage, with path: String)
    func saveBg(image: UIImage, with id: String)
}

final class DocumentManager {
    
    enum DirectoryName: String {
        case qrImages
        case bgImages
    }
    
    static let instance = DocumentManager()
    
    private init() { }
    
    static func createDirectory(name directory: DirectoryName) {
        let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        let url = documentURL.appendingPathComponent(directory.rawValue)
        
        do {
            try FileManager.default.createDirectory(at: url,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Error creating directory: \(error)")
        }
    }
    
    func saveImage(in directory: DirectoryName, image: UIImage, with path: String) {
        let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        let userPhotosURL = documentURL.appendingPathComponent(directory.rawValue)
        
        let userProfileURL = userPhotosURL.appendingPathComponent("\(path).jpg")
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: userProfileURL)
                print("Successfully wrote to file!")
            } catch {
                print("Error writing to file: \(error)")
            }
        }
    }
    
    func loadImage(from directory: DirectoryName, with path: String) -> UIImage? {
        let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        let userPhotosURL = documentURL.appendingPathComponent(directory.rawValue)
        let imageURL = userPhotosURL.appendingPathComponent("\(path).jpg")
        
        guard FileManager.default.fileExists(atPath: imageURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: imageURL)
            return UIImage(data: data)
        } catch {
            print("Error reading file at \(imageURL.path): \(error)")
            return nil
        }
    }
}


extension DocumentManager: DocumentManagerProtocol {
    
    func saveQr(image: UIImage, with id: String) {
        self.saveImage(in: .qrImages, image: image, with: id)
    }
    
    func saveBg(image: UIImage, with id: String) {
        self.saveImage(in: .bgImages, image: image, with: id)
    }
    
    func readQr(with id: String) -> UIImage? {
        loadImage(from: .qrImages, with: id)
    }
    
    func readBg(with id: String) -> UIImage? {
        loadImage(from: .bgImages, with: id)
    }
    
}
