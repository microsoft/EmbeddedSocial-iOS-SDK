//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension User: MementoSerializable {
    init?(memento: Memento) {
        guard let uid = memento["uid"] as? String,
            let credentialsMemento = memento["credentials"] as? Memento,
            let credentials = CredentialsList(memento: credentialsMemento)
            else {
                return nil
        }
        
        self.uid = uid
        self.credentials = credentials
        firstName = memento["firstName"] as? String
        lastName = memento["lastName"] as? String
        email = memento["email"] as? String
        bio = memento["bio"] as? String
        
        let photoMemento = memento["photo"] as? Memento
        photo = photoMemento != nil ? Photo(memento: photoMemento!) : nil
    }
    
    var memento: Memento {
        let memento: [String: Any?] = [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "bio": bio,
            "photo": photo?.memento,
            "credentials": credentials.memento
        ]
        
        return memento.flatMap { $0 }
    }
}
