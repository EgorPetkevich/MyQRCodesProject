//
//  Extension+Seque.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import Foundation

extension Sequence {
    
    func asyncMap<T>(_ transform: (Element) async -> T) async -> [T] {
        var results = [T]()
        for element in self {
            results.append(await transform(element))
        }
        return results
    }
    
}
