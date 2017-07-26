//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct User {
    let uid: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let bio: String?
    let photo: Photo?
    let credentials: CredentialsList
    
    var fullName: String {
        if firstName == nil {
            return lastName != nil ? lastName! : Constants.Placeholder.unknown
        }
        
        if lastName == nil {
            return firstName != nil ? firstName! : Constants.Placeholder.unknown
        }
        
        return "\(firstName!) \(lastName!)"
    }
}

extension User {
    init(socialUser: SocialUser, userHandle: String) {
        uid = userHandle
        firstName = socialUser.firstName
        lastName = socialUser.lastName
        email = socialUser.email
        bio = socialUser.bio
        photo = socialUser.photo
        credentials = socialUser.credentials
    }
}

extension User: Equatable {
    static func ==(_ lhs: User, _ rhs: User) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email &&
            lhs.bio == rhs.bio &&
            lhs.photo == rhs.photo &&
            lhs.credentials == rhs.credentials
    }
}
