//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SectionModelType {
    associatedtype Item
    
    var items: [Item] { get }
}

struct SectionModel<Section, ItemType>: SectionModelType where ItemType: CellModel {
    typealias Item = ItemType
    
    let model: Section
    let items: [Item]
    
    init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
}

extension SectionModel: CustomStringConvertible {
    
    var description: String {
        return "\(self.model) > \(items)"
    }
}
