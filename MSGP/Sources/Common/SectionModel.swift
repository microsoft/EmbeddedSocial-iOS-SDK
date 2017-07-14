//
//  SectionModel.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol SectionModelType {
    associatedtype Item
    
    var items: [Item] { get }
}

struct SectionModel<Section, ItemType>: SectionModelType where ItemType: Reusable {
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
