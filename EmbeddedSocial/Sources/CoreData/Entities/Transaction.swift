//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol Transaction {
    var typeid: String? { get set }
    var createdAt: Date? { get set }
    var handle: String? { get set }
    var payload: Any? { get set }
}
