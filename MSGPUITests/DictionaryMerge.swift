//
//  DictionaryMerge.swift
//  MSGP
//
//  Created by Akvelon on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func update(other: Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
