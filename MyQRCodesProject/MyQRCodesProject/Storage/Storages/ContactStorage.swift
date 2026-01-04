//
//  ContactStorage.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import Combine

final class ContactStorage: BaseStorage<ContactDTO> {
    
    func fetch() -> AnyPublisher<[ContactDTO], Never> {
        let result = super.fetch(
            sortDescriptors: [.byDate()])
            .compactMap { $0 as? ContactDTO }
        
        return Just(result).eraseToAnyPublisher()
        
    }
    
}
