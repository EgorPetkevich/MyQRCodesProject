//
//  Extension+String.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import Foundation

extension String {
    
    func formattedBirthday(
        input: String = "yyyyMMdd",
        output: String = "dd.MM.yyyy"
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = input

        guard let date = formatter.date(from: self) else {
            return self
        }

        formatter.dateFormat = output
        return formatter.string(from: date)
    }
    
    var tecItQRCodeBase: String? {
        guard let url = URL(string: self) else { return nil }
        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host
        components.path = url.path
        return components.url?.absoluteString
    }
    
}
