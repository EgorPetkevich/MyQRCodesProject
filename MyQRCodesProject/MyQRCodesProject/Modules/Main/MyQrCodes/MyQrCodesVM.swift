//
//  MyQrCodesVM.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//

import Foundation
import Combine

final class MyQrCodesVM: ObservableObject {
    
    @Published var selectedSortPill: MyQrCodesSortSection = .all
    @Published var sortedDtos: [any DTODescription] = []
    @Published var selectedDTO: (any DTODescription)?
    @Published var showDetails: Bool = false
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
            .map { dtos in
                dtos.filter { !$0.scanned }
            }
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
    
    private func bind() {
        Publishers.CombineLatest($selectedSortPill, $dtos)
            .map { sortSection, dtos in
                switch sortSection {
                case .all:
                    return dtos
                case .url:
                    return dtos
                        .compactMap { $0 as? LinkDTO }
                    
                case .text:
                    return dtos
                        .compactMap { $0 as? TextDTO }
                    
                case .wifi:
                    return dtos
                        .compactMap { $0 as? WiFiDTO }
                    
                case .contact:
                    return dtos
                        .compactMap { $0 as? ContactDTO }
                    
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.sortedDtos, on: self)
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
}
