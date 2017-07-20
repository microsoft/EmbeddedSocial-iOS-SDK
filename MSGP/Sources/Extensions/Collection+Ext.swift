//
//  Collection+Ext.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension Collection {
    func dictionary<K, V>(transform:(_ element: Iterator.Element) -> [K: V]) -> [K: V] {
        var dictionary: [K: V] = [:]
        for element in self {
            for (key, value) in transform(element) {
                dictionary[key] = value
            }
        }
        return dictionary
    }
}
