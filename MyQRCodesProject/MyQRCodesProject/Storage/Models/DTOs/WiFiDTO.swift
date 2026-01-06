//
//  WiFiDTO.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import CoreData

enum WiFiSecurityType {
    case open
    case wep
    case wpa
    case wpa2
    case wpa3
    case unknown
}

struct WiFiDTO: DTODescription, Identifiable {
    
    typealias MO = WiFiMO
    
    var id: String
    var createdAt: Date
    var ssid: String
    var isHidden: Bool
    var password: String?
    var security: String?
        
    var securityType: WiFiSecurityType {
        guard let security = security?.lowercased() else {
            return .open
        }

        switch security {
        case "wep":
            return .wep
        case "wpa":
            return .wpa
        case "wpa2":
            return .wpa2
        case "wpa3":
            return .wpa3
        case "open", "none":
            return .open
        default:
            return .unknown
        }
    }
    
    var isWEP: Bool {
        securityType == .wep
    }
    
    var canConnect: Bool {
        switch securityType {
        case .open:
            return true
        case .wep, .wpa, .wpa2, .wpa3:
            return password?.isEmpty == false
        case .unknown:
            return false
        }
    }
    
    var securityDisplayName: String {
        switch securityType {
        case .open: return "Open"
        case .wep: return "WEP"
        case .wpa: return "WPA"
        case .wpa2: return "WPA2"
        case .wpa3: return "WPA3"
        case .unknown: return security ?? "Unknown"
        }
    }
    
    init(
        id: String,
        createdAt: Date,
        ssid: String,
        isHidden: Bool,
        password: String?,
        security: String?
    ){
        self.id = id
        self.createdAt = createdAt
        self.ssid = ssid
        self.isHidden = isHidden
        self.password = password
        self.security = security
    }
    
    init?(mo: WiFiMO) {
        guard
            let id = mo.id,
            let createdAt = mo.createdAt,
            let ssid = mo.ssid
        else { return nil }
        self.id = id
        self.createdAt = createdAt
        self.ssid = ssid
        self.isHidden = mo.isHidden
        self.password = mo.password
        self.security = mo.security
    }
    
    func createMO(context: NSManagedObjectContext) -> WiFiMO? {
        let mo = WiFiMO(context: context)
        mo.apply(dto: self)
        return mo
    }
}

extension WiFiDTO: QRCodePayloadConvertible {
    var qrPayload: String {
        let type: String = {
            switch securityType {
            case .wep: return "WEP"
            case .wpa, .wpa2, .wpa3: return "WPA"
            case .open: return "nopass"
            case .unknown: return "nopass"
            }
        }()
        
        let ssidPart = "S:\(ssid);"
        let passPart = password.map { "P:\($0);" } ?? ""
        let hiddenPart = "H:\(isHidden ? "true" : "false");"
        
        return "WIFI:T:\(type);\(ssidPart)\(passPart)\(hiddenPart);;"
    }
}
