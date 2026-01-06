//
//  DefaultQRCodeGenerator.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import UIKit

protocol QRCodeGeneratorProtocol {
    func generate(from payload: QRCodePayloadConvertible) -> UIImage?
}

final class DefaultQRCodeGenerator: QRCodeGeneratorProtocol {

    func generate(from payload: QRCodePayloadConvertible) -> UIImage? {
        generate(from: payload.qrPayload)
    }

    private func generate(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)

        return UIImage(ciImage: scaledImage)
    }
}
