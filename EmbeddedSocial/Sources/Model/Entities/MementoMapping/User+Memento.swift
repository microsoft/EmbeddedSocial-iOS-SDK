//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension User: MementoSerializable {
    init?(memento: Memento) {
        guard let uid = memento["uid"] as? String else {
            return nil
        }
        
        self.uid = uid
        
        firstName = memento["firstName"] as? String
        lastName = memento["lastName"] as? String
        email = memento["email"] as? String
        bio = memento["bio"] as? String
        followersCount = (memento["followersCount"] as? Int) ?? 0
        followingCount = (memento["followingCount"] as? Int) ?? 0
        
        let photoMemento = memento["photo"] as? Memento
        photo = photoMemento != nil ? Photo(memento: photoMemento!) : nil
        
        let credentialsMemento = memento["credentials"] as? Memento
        credentials = credentialsMemento != nil ? CredentialsList(memento: credentialsMemento!) : nil
        
        if let rawVisibility = memento["visibility"] as? String,
            let visibility = Visibility(rawValue: rawVisibility) {
            self.visibility = visibility
        } else {
            visibility = nil
        }
        
        if let rawFollowerStatus = memento["followerStatus"] as? Int,
            let followerStatus = FollowStatus(rawValue: rawFollowerStatus) {
            self.followerStatus = followerStatus
        } else {
            followerStatus = nil
        }
        
        if let rawFollowingStatus = memento["followingStatus"] as? Int,
            let followingStatus = FollowStatus(rawValue: rawFollowingStatus) {
            self.followingStatus = followingStatus
        } else {
            followingStatus = nil
        }
    }
    
    var memento: Memento {
        let memento: [String: Any?] = [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "bio": bio,
            "photo": photo?.memento,
            "credentials": credentials?.memento,
            "followersCount": followersCount,
            "followingCount": followingCount,
            "visibility": visibility?.rawValue,
            "followerStatus": followerStatus?.rawValue,
            "followingStatus": followingStatus?.rawValue
        ]
        
        return memento.flatMap { $0 }
    }
}
