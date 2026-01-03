//
//  DefaultTextProcessor.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import Foundation

protocol TextProcessingProtocol {
    func detectPhone(in text: String) -> String?
    func detectMail(in text: String) -> String?
    func detectURL(in text: String) -> URL?
    func detectGeolocation(in text: String) -> String?
}

final class DefaultTextProcessor: TextProcessingProtocol {
    
    func detectPhone(in text: String) -> String? {
        do {
            let cleanedText = text.replacingOccurrences(of: "tel:", with: "")
            
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let match = detector.firstMatch(in: cleanedText, range: NSRange(cleanedText.startIndex..., in: cleanedText))

            return match?.phoneNumber
        } catch {
            return nil
        }
    }

    
    func detectURL(in text: String) -> URL? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let match = detector.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))
            return match?.url
        } catch {
            return nil
        }
    }
    
    func detectMail(in text: String) -> String? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let match = detector.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))
        
            if let url = match?.url, url.scheme == "mailto" {
                return url.absoluteString.replacingOccurrences(of: "mailto:", with: "")
            }
        } catch {
            return nil
        }
        return nil
    }

    
    func detectGeolocation(in text: String) -> String? {
        let pattern = #"([-+]?\d{1,3}\.\d+),\s*([-+]?\d{1,3}\.\d+)"#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(text.startIndex..., in: text)
            
            if let match = regex.firstMatch(in: text, range: range) {
                if let matchRange = Range(match.range, in: text) {
                    return String(text[matchRange])
                }
            }
        } catch {
            return nil
        }
        return nil
    }




}
