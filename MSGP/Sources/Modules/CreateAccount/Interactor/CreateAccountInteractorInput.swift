//
//  CreateAccountCreateAccountInteractorInput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol CreateAccountInteractorInput {
    func createAccount(email: String, password: String, completion: @escaping (Result<User>) -> Void)
}
