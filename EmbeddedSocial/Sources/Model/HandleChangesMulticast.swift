//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class HandleChangesMulticast: Publisher {
    
    static let shared = HandleChangesMulticast()
    
    private let multicast = MulticastDelegate<Subscriber>()
    
    func notify(_ hint: Hint) {
        multicast.invoke { $0.update(hint) }
    }
    
    func subscribe(_ subscriber: Subscriber) {
        multicast.add(subscriber)
    }
}
