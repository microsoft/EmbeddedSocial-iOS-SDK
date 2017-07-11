//
//  User.swift
//  SocialPlusv0
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

struct User {
    let name: String?
    let email: String?
    let bio: String?
    let phoneNumber: String?
    let token: String?
    let photo: Photo?
    let provider: AuthProvider
    
    init(name: String? = nil,
         email: String? = nil,
         bio: String? = nil,
         phoneNumber: String? = nil,
         token: String? = nil,
         photo: Photo? = nil,
         provider: AuthProvider) {
        self.name = name
        self.email = email
        self.bio = bio
        self.phoneNumber = phoneNumber
        self.token = token
        self.photo = photo
        self.provider = provider
    }
}

extension User: Hashable {
    var hashValue: Int {
        let nonNilFields = [name, email, bio, phoneNumber, token].flatMap { $0 }
        return nonNilFields.reduce(1, { (result, field) in
            return result ^ field.hashValue
        })
    }
    
    static func ==(_ lhs: User, _ rhs: User) -> Bool {
        return lhs.name == rhs.name &&
            lhs.email == rhs.email &&
            lhs.bio == rhs.bio &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.token == rhs.token &&
            lhs.photo == rhs.photo
    }
}
