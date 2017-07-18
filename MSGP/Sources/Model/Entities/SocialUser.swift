//
//  SocialUser.swift
//  SocialPlusv0
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

struct SocialUser {
    let uid: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let bio: String?
    let photo: Photo?
    let credentials: CredentialsList

    init(uid: String,
         token: String,
         requestToken: String? = nil,
         firstName: String?,
         lastName: String?,
         email: String?,
         bio: String? = nil,
         photo: Photo?,
         provider: AuthProvider) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.bio = bio
        self.photo = photo
        credentials = CredentialsList(provider: provider, accessToken: token, requestToken: requestToken, socialUID: uid)
    }
}

extension SocialUser: Equatable {
    static func ==(_ lhs: SocialUser, _ rhs: SocialUser) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email &&
            lhs.bio == rhs.bio &&
            lhs.photo == rhs.photo &&
            lhs.credentials == rhs.credentials
    }
}
