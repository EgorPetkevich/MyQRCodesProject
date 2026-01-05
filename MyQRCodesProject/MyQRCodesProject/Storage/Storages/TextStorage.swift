//
//  TextStorage.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 5.01.26.
//

import Foundation
import Combine

final class TextStorage: BaseStorage<TextDTO> {
    
    func fetch() -> AnyPublisher<[TextDTO], Never> {
        let result = super.fetch(
            sortDescriptors: [.byDate()])
            .compactMap { $0 as? TextDTO }
        
        return Just(result).eraseToAnyPublisher()
        
    }
    
}
