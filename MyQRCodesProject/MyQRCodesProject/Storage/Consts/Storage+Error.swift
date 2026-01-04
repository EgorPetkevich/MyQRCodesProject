//
//  Storage+Error.swift
//  ESign
//
//  Created by George Popkich on 7.11.25.
//

import Foundation

enum StorageError: Error {
    case cannotCreate
    case cannotSave
    case cannotDelete
    case cannotRename
}
