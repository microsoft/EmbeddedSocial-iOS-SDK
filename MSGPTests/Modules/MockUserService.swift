//
//  MockUserService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

@testable import MSGP

final class MockUserService: UserServiceType {
    private(set) var getMyProfileCount = 0
    private(set) var createAccountCount = 0

    func getMyProfile(socialUser: SocialUser, completion: @escaping (Result<User>) -> Void) {
        getMyProfileCount += 1
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        createAccountCount += 1
    }
}
