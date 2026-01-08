//
//  HistoryVM.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import Foundation
import Combine
import UIKit

final class HistoryVM: ObservableObject {
    
    @Published var selectedSortPill: HistorySortSection = .all
    @Published var sortedDtos: [any DTODescription] = []
    @Published var groupedDtos: [String: [any DTODescription]] = [:] // Dictionary to store DTOs by date
    @Published var selectedDTO: (any DTODescription)?
    @Published var showDetails: Bool = false
    @Published var showCopiedToast = false
    @Published var showShareSheet = false
    @Published var shareItems: [Any] = []
    
    @Published private var dtos: [any DTODescription] = []
    
    private var storage: QRCodesFetchServiceProtocol
    private let qrGenerator: QRCodeGeneratorProtocol
    private var bag: Set<AnyCancellable> = []
    
    init(storage: QRCodesFetchServiceProtocol,
         qrGenerator: QRCodeGeneratorProtocol) {
        self.storage = storage
        self.qrGenerator = qrGenerator
        bind()
        fetchData()
    }
    
    private func fetchData() {
        storage.fetchAll()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dtos in
                self?.dtos = dtos
            }
            .store(in: &bag)
        $selectedDTO
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dto in
                guard let _ = dto else { return }
                self?.showDetails = true
            }
            .store(in: &bag)
    }

    private func groupDtosByDate(from dtos: [any DTODescription]) {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: dtos) { dto in
            let date = calendar.startOfDay(for: dto.createdAt)
            return dateFormatter.string(from: date)
        }
        self.groupedDtos = grouped
    }
    
    // DateFormatter for formatting date as string (e.g., "Today", "Yesterday")
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private func bind() {
        Publishers.CombineLatest($selectedSortPill, $dtos)
            .map { sortSection, dtos in
                switch sortSection {
                case .all:
                    return dtos
                case .scanned:
                    return dtos.filter { $0.scanned == true }
                case .created:
                    return dtos.filter { $0.scanned == false }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filteredDtos in
                self?.sortedDtos = filteredDtos
                self?.groupDtosByDate(from: filteredDtos)
            }
            .store(in: &bag)
    }
    
    func delete(_ dto: any DTODescription) {
        storage.delete(id: dto.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                },
                receiveValue: { [weak self] in
                    self?.dtos.removeAll { $0.id == dto.id }
                }
            )
            .store(in: &bag)
    }
    
    func share(_ dto: any DTODescription) {
        switch dto {
        case let wifiDTO as WiFiDTO:
            shareItems = [wifiText(from: wifiDTO)]
        case let textDTO as TextDTO:
            shareItems = [textDTO.text]
        case let linkDTO as LinkDTO:
            if let url = URL(string: linkDTO.link) {
                shareItems = [url]
            }
        case let contactDTO as ContactDTO:
            shareContactDTO(contactDTO)
        default:
            return
        }
        
        showShareSheet = !shareItems.isEmpty
    }
    
    func copy(_ dto: any DTODescription) {
        switch dto {
            case let wifiDTO as WiFiDTO:
            copyStr(wifiDTO.ssid)
        case let textDTO as TextDTO:
            copyStr(textDTO.text)
        case let linkDTO as LinkDTO:
            copyStr(linkDTO.link)
        case let contactDTO as ContactDTO:
            copyStr("\(contactDTO.firstName ?? "") \(contactDTO.lastName ?? "")")
        default:
            break
        }
    }
    
    // MARK: - Private helpers
   
    private func shareContactDTO(_ contactDTO: ContactDTO) {
        let vCard = qrGenerator.makeVCard(from: contactDTO)
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("contact.vcf")
        
        do {
            try vCard.write(to: url, atomically: true, encoding: .utf8)
            
            DispatchQueue.main.async {
                self.shareItems = [url]
            }
        } catch {
            print("Failed to share:", error)
        }
    }

    private func wifiText(from wifiDTO: WiFiDTO) -> String {
         """
         Wi-Fi Network
         SSID: \(wifiDTO.ssid)
         Security: \(wifiDTO.securityDisplayName)
         Password: \(wifiDTO.password ?? "—")
         """
     }
    
    private func copyStr(_ str: String) {
        UIPasteboard.general.string = str
        showCopiedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showCopiedToast = false
        }
    }
}

