//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol Publisher {
    func subscribe(_ subscriber: Subscriber)
    func notify(_ hint: Hint)
}

protocol Subscriber: class {
    func update(_ hint: Hint)
}

protocol Hint {
    
}

protocol HandleUpdateHint: Hint {
    var oldHandle: String { get }
    var newHandle: String { get }
}
