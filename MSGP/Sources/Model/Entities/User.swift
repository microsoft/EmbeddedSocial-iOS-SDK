//
//  User.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
