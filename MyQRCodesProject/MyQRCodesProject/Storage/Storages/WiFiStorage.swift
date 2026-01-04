//
//  WiFiStorage.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import Combine

final class WiFiStorage: BaseStorage<WiFiDTO> {
    
    func fetch() -> AnyPublisher<[WiFiDTO], Never> {
        let result = super.fetch(
            sortDescriptors: [.byDate()])
            .compactMap { $0 as? WiFiDTO }
        
        return Just(result).eraseToAnyPublisher()
        
    }
    
}
