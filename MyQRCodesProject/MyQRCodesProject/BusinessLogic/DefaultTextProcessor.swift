//
//  DefaultTextProcessor.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import Foundation

struct WiFiNetwork {
    let ssid: String
    let password: String?
    let security: String?
    let isHidden: Bool
}

struct VCard {
    var address: String?
    var birthday: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var jobTitle: String?
    var organization: String?
    var phoneNumber: String?
    var phoneNumberWork: String?
    var prefix: String?
    var website: String?
}

protocol TextProcessingProtocol {
    func detectURL(in text: String) -> URL?
    func detectWiFi(in text: String) -> WiFiNetwork?
    func detectVCard(in text: String) -> VCard?
}

final class DefaultTextProcessor: TextProcessingProtocol {
    
    // MARK: - URL
    func detectURL(in text: String) -> URL? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let match = detector.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))
            return match?.url
        } catch {
            return nil
        }
    }
    
    // MARK: - WiFi
    func detectWiFi(in text: String) -> WiFiNetwork? {
        let upper = text.uppercased()
        guard upper.hasPrefix("WIFI:") else { return nil }

        var ssid: String?
        var password: String?
        var security: String?
        var hidden = false

        // drop WIFI:
        let body = text.dropFirst(5)

        let parts = body.split(separator: ";", omittingEmptySubsequences: true)

        for part in parts {
            guard let separatorIndex = part.firstIndex(of: ":") else { continue }

            let key = part[..<separatorIndex].uppercased()
            let value = String(part[part.index(after: separatorIndex)...])
                .replacingOccurrences(of: #"\\:"# , with: ":", options: .regularExpression)
                .replacingOccurrences(of: #"\\;"# , with: ";", options: .regularExpression)

            switch key {
            case "S":
                ssid = value
            case "P":
                password = value
            case "T":
                security = value
            case "H":
                hidden = value.lowercased() == "true"
            default:
                break
            }
        }

        guard let ssid else { return nil }

        return WiFiNetwork(
            ssid: ssid,
            password: password,
            security: security,
            isHidden: hidden
        )
    }
    
    // MARK: - vCard
    func detectVCard(in text: String) -> VCard? {
        guard text.uppercased().contains("BEGIN:VCARD"),
              text.uppercased().contains("END:VCARD") else { return nil }
        
        var card = VCard()
        
        let lines = text
            .replacingOccurrences(of: "\r\n", with: "\n")
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        for line in lines {
            
            // FN;CHARSET=UTF-8:John Doe
            if line.uppercased().hasPrefix("FN"),
               let value = line.split(separator: ":", maxSplits: 1).last {
                
                let fullName = String(value)
                let parts = fullName.split(separator: " ", maxSplits: 1)
                
                card.firstName = parts.indices.contains(0) ? String(parts[0]) : nil
                card.lastName  = parts.indices.contains(1) ? String(parts[1]) : nil
            }
            
            // N:Doe;John;;;
            else if line.uppercased().hasPrefix("N:"),
                    let value = line.split(separator: ":", maxSplits: 1).last {
                
                let parts = value.split(separator: ";", omittingEmptySubsequences: false)
                card.lastName  = parts.indices.contains(0) ? String(parts[0]) : card.lastName
                card.firstName = parts.indices.contains(1) ? String(parts[1]) : card.firstName
                card.prefix    = parts.indices.contains(3) ? String(parts[3]) : nil
            }
            
            else if line.uppercased().hasPrefix("TEL"),
                    let value = line.split(separator: ":", maxSplits: 1).last {
                
                if line.uppercased().contains("WORK") {
                    card.phoneNumberWork = String(value)
                } else {
                    card.phoneNumber = String(value)
                }
            }
            
            else if line.uppercased().hasPrefix("EMAIL"),
                    let value = line.split(separator: ":", maxSplits: 1).last {
                card.email = String(value)
            }
            
            else if line.uppercased().hasPrefix("ORG:") {
                card.organization = String(line.dropFirst(4))
            }
            
            else if line.uppercased().hasPrefix("TITLE:") {
                card.jobTitle = String(line.dropFirst(6))
            }
            
            else if line.uppercased().hasPrefix("ADR"),
                    let value = line.split(separator: ":", maxSplits: 1).last {
                
                let parts = value.split(separator: ";").filter { !$0.isEmpty }
                card.address = parts.joined(separator: ", ")
            }
            
            else if line.uppercased().hasPrefix("BDAY:") {
                card.birthday = String(line.dropFirst(5))
            }
            
            else if line.uppercased().hasPrefix("URL"),
                    let value = line.split(separator: ":", maxSplits: 1).last {
                card.website = String(value)
            }
        }
        
        return card
    }
}
