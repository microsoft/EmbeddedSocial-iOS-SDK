//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
