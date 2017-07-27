//
//  UserProfileRouterInput.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol UserProfileRouterInput {
    func openFollowers(user: User)
    
    func openFollowing(user: User)
    
    func openEditProfile(user: User)
}
