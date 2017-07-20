//
//  MockAuthAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
@testable import MSGP

struct MockAuthAPI: AuthAPI {
    private let result: Result<SocialUser>
    
    init(resultToReturn: Result<SocialUser>) {
        result = resultToReturn
    }
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        handler(result)
    }
}
