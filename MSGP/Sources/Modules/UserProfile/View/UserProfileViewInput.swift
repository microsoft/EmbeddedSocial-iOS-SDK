//
//  UserProfileViewInput.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol UserProfileViewInput: class {
    func setupInitialState()
    
    func showError(_ error: Error)
    
    func setIsLoading(_ isLoading: Bool)
    
    func setUser(_ user: User)
    
    func setFollowStatus(_ followStatus: FollowStatus)
    
    func setIsProcessingFollowRequest(_ isLoading: Bool)
}
