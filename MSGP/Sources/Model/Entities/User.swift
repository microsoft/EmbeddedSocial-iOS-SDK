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
