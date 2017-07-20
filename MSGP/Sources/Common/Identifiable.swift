//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol Identifiable: CustomStringConvertible {
    var identifier: String { get }
}

extension Identifiable {
    var description: String {
        return identifier
    }
}
