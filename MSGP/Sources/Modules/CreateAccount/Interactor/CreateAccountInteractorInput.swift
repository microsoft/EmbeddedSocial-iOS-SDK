//
//  CreateAccountCreateAccountInteractorInput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol CreateAccountInteractorInput {
    func createAccount(for user: SocialUser, completion: @escaping (Result<SocialUser>) -> Void)
}
