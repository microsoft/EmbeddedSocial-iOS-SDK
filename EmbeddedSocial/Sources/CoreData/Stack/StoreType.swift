//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import CoreData

enum StoreType {
    case sqlite(URL)
    case binary(URL)
    case inMemory
    
    var type: String {
        switch self {
        case .sqlite: return NSSQLiteStoreType
        case .binary: return NSBinaryStoreType
        case .inMemory: return NSInMemoryStoreType
        }
    }
    
    func storeDirectory() -> URL? {
        switch self {
        case let .sqlite(url): return url
        case let .binary(url): return url
        case .inMemory: return nil
        }
    }
}

extension StoreType: Equatable {
    static func ==(_ lhs: StoreType, _ rhs: StoreType) -> Bool {
        switch (lhs, rhs) {
        case let (.sqlite(left), .sqlite(right)) where left == right:
            return true
        case let (.binary(left), .binary(right)) where left == right:
            return true
        case (.inMemory, .inMemory):
            return true
        default:
            return false
        }
    }
}
