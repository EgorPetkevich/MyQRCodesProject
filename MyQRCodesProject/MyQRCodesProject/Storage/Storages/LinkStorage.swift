//
//  LinkStorage.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import Combine

final class LinkStorage: BaseStorage<LinkDTO> {
    
    func fetch() -> AnyPublisher<[LinkDTO], Never> {
        let result = super.fetch(
            sortDescriptors: [.byDate()])
            .compactMap { $0 as? LinkDTO }
        
        return Just(result).eraseToAnyPublisher()
        
    }
    
}
