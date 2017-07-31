//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct Fonts {
    static let small = UIFont.systemFont(ofSize: 12.0)
    static let medium = UIFont.systemFont(ofSize: 14.0)
    static let regular = UIFont.systemFont(ofSize: 16.0)
}

// swiftlint:disable type_name
extension Fonts {
    struct bold {
        static let small = UIFont.boldSystemFont(ofSize: 12.0)
        static let regular = UIFont.boldSystemFont(ofSize: 16.0)
        static let large = UIFont.boldSystemFont(ofSize: 20.0)
    }
}
