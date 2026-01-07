//
//  QRCodesFetchService.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//

import Foundation
import Combine

protocol QRCodesFetchServiceProtocol {
    func fetchAll() -> AnyPublisher<[any DTODescription], Never>
    func delete(id: String) -> AnyPublisher<Void, StorageError>
//    func edit(newDTO: any DTODescription)
}

final class QRCodesFetchService: QRCodesFetchServiceProtocol {

    private let textStorage = TextStorage()
    private let wifiStorage = WiFiStorage()
    private let contactStorage = ContactStorage()
    private let linkStorage = LinkStorage()
    
    private let refresh = PassthroughSubject<Void, Never>()

    func fetchAll() -> AnyPublisher<[any DTODescription], Never> {
        refresh
            .prepend(())
            .flatMap { [unowned self] _ in
                Publishers.CombineLatest4(
                    textStorage.fetch(),
                    wifiStorage.fetch(),
                    contactStorage.fetch(),
                    linkStorage.fetch()
                )
            }
            .map { texts, wifis, contacts, links in
                let all: [any DTODescription] = texts + wifis + contacts + links
                return all.sorted { $0.createdAt > $1.createdAt }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Delete
    
    func delete(id: String) -> AnyPublisher<Void, StorageError> {
        Publishers.MergeMany(
            textStorage.delete(id: id),
            wifiStorage.delete(id: id),
            contactStorage.delete(id: id),
            linkStorage.delete(id: id)
        )
        .first()
        .handleEvents(receiveOutput: { [weak self] _ in
            self?.refresh.send(())
        })
        .eraseToAnyPublisher()
    }
    
    // MARK: - Edit
    
//    func edit(newDTO: any DTODescription) {
//        switch newDTO {
//        case let text as TextDTO:
//            textStorage.update(text)
//            
//        case let wifi as WiFiDTO:
//            wifiStorage.update(wifi)
//            
//        case let contact as ContactDTO:
//            contactStorage.update(contact)
//            
//        case let link as LinkDTO:
//            linkStorage.update(link)
//            
//        default:
//            return
//        }
//    }
    
}
