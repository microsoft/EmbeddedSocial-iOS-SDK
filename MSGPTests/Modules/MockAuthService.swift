//
//  MockAuthService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

@testable import MSGP

final class MockAuthService: AuthServiceType {
    private(set) var loginCount = 0
    
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               handler: @escaping (Result<SocialUser>) -> Void) {
        loginCount += 1
    }
}
