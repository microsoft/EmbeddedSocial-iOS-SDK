//
//  User.swift
//  SocialPlusv0
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

struct User {
    let firstName: String?
    let lastName: String?
    let email: String?
    let bio: String?
    let token: String?
    let photo: Photo?
    let provider: AuthProvider

    init(firstName: String? = nil,
         lastName: String? = nil,
         email: String? = nil,
         bio: String? = nil,
         token: String? = nil,
         photo: Photo? = nil,
         provider: AuthProvider) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.bio = bio
        self.token = token
        self.photo = photo
        self.provider = provider
    }
}

extension User: Hashable {
    
    var hashValue: Int {
        let fields: [AnyHashable?] = [firstName, lastName, email, bio, token, photo?.url, provider.rawValue]
        let nonNilFields = fields.flatMap { $0 }
        return nonNilFields.reduce(1, { (result, field) in
            return result ^ field.hashValue
        })
    }
    
    static func ==(_ lhs: User, _ rhs: User) -> Bool {
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email &&
            lhs.bio == rhs.bio &&
            lhs.token == rhs.token &&
            lhs.photo == rhs.photo &&
            lhs.provider == rhs.provider
    }
}
