//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension String: MementoSerializable {
    var memento: Memento {
        return ["self": self]
    }
    
    init?(memento: Memento) {
        if let string = memento["self"] as? String {
            self = string
        } else {
            return nil
        }
    }
}
