//
//  CreateAccountCreateAccountViewInput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

protocol CreateAccountViewInput: class {
    func setupInitialState(with user: User)
    
    func setUser(_ user: User)
    
    func showError(_ error: Error)
}
