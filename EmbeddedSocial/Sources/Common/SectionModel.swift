//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SectionModelType {
    associatedtype Item
    
    var items: [Item] { get set }
}

struct SectionModel<Section, ItemType>: SectionModelType {
    typealias Item = ItemType
    
    var model: Section
    var items: [Item]
    
    init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
    
    mutating func erase() {
        items = []
    }
}

extension SectionModel: CustomStringConvertible {
    
    var description: String {
        return "\(self.model) > \(items)"
    }
}
