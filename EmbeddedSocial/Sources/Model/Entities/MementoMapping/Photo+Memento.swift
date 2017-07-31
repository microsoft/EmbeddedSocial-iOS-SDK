//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension Photo: MementoSerializable {
    init?(memento: Memento) {
        guard let uid = memento["uid"] as? String else {
            return nil
        }
        
        self.uid = uid
        url = memento["url"] as? String
        image = nil
    }
    
    var memento: Memento {
        let memento: [String: Any?] = [
            "uid": uid,
            "url": url
        ]
        
        return memento.flatMap { $0 }
    }
}
