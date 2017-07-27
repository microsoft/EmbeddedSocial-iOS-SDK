//
//  UserProfileViewOutput.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol UserProfileViewOutput {
    func viewIsReady()
    
    func onEdit()
    
    func onFollowing()
    
    func onFollowRequest(currentStatus followStatus: FollowStatus)
    
    func onFollowers()
}
