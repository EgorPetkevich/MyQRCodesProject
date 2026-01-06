//
//  CreateQRFormView.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

enum CreateField: Hashable {
    case url
    case text
    case firstName
    case lastName
    case phone
    case email
    case ssid
    case password
}

enum WiFiSecurity: String, CaseIterable {
    case open
    case wep
    case wpa
    case wpa2
    case wpa3
    case unknown
    
    var displayName: String {
        switch self {
        case .open: return "Open"
        case .wep: return "WEP"
        case .wpa: return "WPA"
        case .wpa2: return "WPA2"
        case .wpa3: return "WPA3"
        case .unknown: return "Unknown"
        }
    }
}

struct CreateQRFormView: View {
    
    @ObservedObject var vm: CreateVM
    var focusedField: FocusState<CreateField?>.Binding
    
    var body: some View {
        VStack(spacing: 16) {
            
            switch vm.selectedType {
            case .url:
                VStack(alignment: .leading, spacing: 4) {
                    InputField(
                        title: "Website URL",
                        placeholder: "https://example.com",
                        text: $vm.urlText
                    )
                    .focused(focusedField, equals: .url)
                    
                    if let error = vm.errorLink {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }
                }
                .id(CreateField.url)
                
            case .text:
                VStack(alignment: .leading, spacing: 4) {
                    InputField(
                        title: "Text",
                        placeholder: "Enter text",
                        text: $vm.plainText
                    )
                    .focused(focusedField, equals: .text)
                    .id(CreateField.text)
                    
                    if let error = vm.errorText {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }
                }
                
            case .contact:
                VStack(spacing: 12) {
                    InputField(
                        title: "First Name",
                        placeholder: "John",
                        text: $vm.firstName
                    )
                    .focused(focusedField, equals: .firstName)
                    .id(CreateField.firstName)
                    
                    InputField(
                        title: "Last Name",
                        placeholder: "Doe",
                        text: $vm.lastName
                    )
                    .focused(focusedField, equals: .lastName)
                    .id(CreateField.lastName)
                    
                    InputField(
                        title: "Phone",
                        placeholder: "+123456789",
                        text: $vm.phone
                    )
                    .focused(focusedField, equals: .phone)
                    .id(CreateField.phone)
                    
                    InputField(
                        title: "Email",
                        placeholder: "mail@example.com",
                        text: $vm.email)
                    .focused(focusedField, equals: .email
                    )
                    .id(CreateField.email)
                    
                    if let error = vm.errorContact {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 4)
                    }
                }
                
            case .wifi:
                VStack(spacing: 12) {
                    InputField(
                        title: "SSID",
                        placeholder: "My Wi-Fi",
                        text: $vm.ssid
                    )
                    .focused(focusedField, equals: .ssid)
                    .id(CreateField.ssid)
                    
                    if let error = vm.errorWifi {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 4)
                    }
                    
                    InputField(title: "Password", placeholder: "••••••••", text: $vm.password)
                        .focused(focusedField, equals: .password)
                        .id(CreateField.password)
                    
                    HStack() {
                        Text("Security")
                            .inter(size: 14, style: .medium)
                            .foregroundColor(.appTextPrimary)
                        
                        Spacer()
                        
                        Picker("Security", selection: $vm.wifiSecurity) {
                            ForEach(WiFiSecurity.allCases, id: \.self) { security in
                                Text(security.displayName).tag(security)
                            }
                            .foregroundStyle(.appTextPrimary)
                        }
                        .pickerStyle(.menu)
                        .foregroundStyle(.appTextPrimary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appTextBorder, lineWidth: 1)
                            .background(Color.white.cornerRadius(12))
                    )
                    
                    Toggle("Hidden network", isOn: $vm.isHidden)
                        .font(.inter(size: 15, style: .regular))
                        .foregroundStyle(.appTextPrimary)
                    
                }
            }
        }
    }
}
