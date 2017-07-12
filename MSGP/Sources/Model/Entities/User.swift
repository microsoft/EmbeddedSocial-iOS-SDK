//
//  User.swift
//  MSGP-Framework
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

struct User {
    let username: String
}

extension User: Hashable {
    var hashValue: Int {
        return username.hashValue
    }
    
    static func ==(_ lhs: User, _ rhs: User) -> Bool {
        return lhs.username == rhs.username
    }
}
