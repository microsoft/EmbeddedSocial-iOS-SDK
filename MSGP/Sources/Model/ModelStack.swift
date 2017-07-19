//
//  ModelStack.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class ModelStack {
    let user: User
    let sessionToken: String
    
    init(user: User, sessionToken: String) {
        self.user = user
        self.sessionToken = sessionToken
    }
}
