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
    let token: String
    let requestToken: String? // used for Twitter only
    let firstName: String?
    let lastName: String?
    let email: String?
    let photo: Photo?
    let provider: AuthProvider

    init(uid: String,
         token: String,
         requestToken: String? = nil,
         firstName: String?,
         lastName: String?,
         email: String?,
         photo: Photo?,
         provider: AuthProvider) {
        self.uid = uid
        self.token = token
        self.requestToken = requestToken
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.photo = photo
        self.provider = provider
    }
}

extension SocialUser: Hashable {
    
    var hashValue: Int {
        let fields: [AnyHashable?] = [uid, token, firstName, lastName, email, photo?.uid, provider.rawValue]
        let nonNilFields = fields.flatMap { $0 }
        return nonNilFields.reduce(1, { (result, field) in
            return result ^ field.hashValue
        })
    }
    
    static func ==(_ lhs: SocialUser, _ rhs: SocialUser) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email &&
            lhs.token == rhs.token &&
            lhs.photo == rhs.photo &&
            lhs.provider == rhs.provider
    }
}
