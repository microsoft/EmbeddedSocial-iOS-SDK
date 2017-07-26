//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

struct MementoSerializableItem {
    let uid: String
    let name: String
}

extension MementoSerializableItem: Equatable {
    static func ==(lhs: MementoSerializableItem, rhs: MementoSerializableItem) -> Bool {
        let areEqual = lhs.name == rhs.name && lhs.uid == rhs.uid
        if areEqual {
            assertDumpsEqual(lhs, rhs)
        }
        return areEqual
    }
}

extension MementoSerializableItem: MementoSerializable {
    var memento: Memento {
        return ["uid": uid, "name": name]
    }
    
    init?(memento: Memento) {
        guard let name = memento["name"] as? String, let uid = memento["uid"] as? String else {
            return nil
        }
        self.name = name
        self.uid = uid
    }
}
