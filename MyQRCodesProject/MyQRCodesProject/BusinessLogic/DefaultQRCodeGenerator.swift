//
//  DefaultQRCodeGenerator.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import UIKit

protocol QRCodeGeneratorProtocol {
    func generate(from string: String) -> UIImage?
    func makeVCard(from dto: ContactDTO) -> String
}

final class DefaultQRCodeGenerator: QRCodeGeneratorProtocol {

    func generate(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)

        let context = CIContext()
        guard
            let cgImage = context.createCGImage(scaledImage,
                                                from: scaledImage.extent)
        else { return nil }

        return UIImage(cgImage: cgImage)
    }
    
    func makeVCard(from dto: ContactDTO) -> String {
        var vCard = """
        BEGIN:VCARD
        VERSION:3.0
        """
        
        if let firstName = dto.firstName,
           let lastName = dto.lastName {
            vCard += "\nN:\(lastName);\(firstName);;;"
            vCard += "\nFN:\(firstName) \(lastName)"
        }
        
        if let phone = dto.phoneNumber {
            vCard += "\nTEL;TYPE=CELL:\(phone)"
        }
        
        if let workPhone = dto.phoneNumberWork {
            vCard += "\nTEL;TYPE=WORK:\(workPhone)"
        }
        
        if let email = dto.email {
            vCard += "\nEMAIL:\(email)"
        }
        
        if let organization = dto.organization {
            vCard += "\nORG:\(organization)"
        }
        
        if let jobTitle = dto.jobTitle {
            vCard += "\nTITLE:\(jobTitle)"
        }
        
        if let address = dto.address {
            vCard += "\nADR;TYPE=HOME:;;\(address);;;;;"
        }
        
        if let birthday = dto.birthday {
            vCard += "\nBDAY:\(birthday)"
        }
        
        vCard += "\nEND:VCARD"
        
        return vCard
    }
    
}
