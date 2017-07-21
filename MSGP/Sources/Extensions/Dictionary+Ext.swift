//
//  Dictionary+Ext.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension Dictionary {
    func flatMap<ElementOfResult>(transform: ((Key, Value)) -> (Key, ElementOfResult?)) -> [Key: ElementOfResult] {
        return map(transform)
            .filter { $0.1 != nil }
            .map { ($0.0, $0.1!) }
            .dictionary { [$0.0: $0.1] }
    }
}
