//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension Cache {
    
    static var createdAtSortDescriptor: NSSortDescriptor {
        return NSSortDescriptor(key: "createdAt", ascending: true)
    }
}
