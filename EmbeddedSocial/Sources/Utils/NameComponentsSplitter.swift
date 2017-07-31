//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct NameComponentsSplitter {
    
    static func split(fullName: String) -> (String?, String?) {
        guard !fullName.isEmpty else {
            return (nil, nil)
        }
        let components = fullName.components(separatedBy: .whitespacesAndNewlines)
        let lastName = components.last
        let firstName = components.dropLast().joined(separator: " ")
        return (firstName.isEmpty ? nil : firstName, lastName)
    }
}
