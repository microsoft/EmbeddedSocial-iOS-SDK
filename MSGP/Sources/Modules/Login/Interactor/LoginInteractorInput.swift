//
//  LoginLoginInteractorInput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol LoginInteractorInput {
    func login(provider: AuthProvider, from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void)
    
    func getMyProfile(socialUser: SocialUser, handler: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
}
