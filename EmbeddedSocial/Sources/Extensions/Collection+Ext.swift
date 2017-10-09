//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
