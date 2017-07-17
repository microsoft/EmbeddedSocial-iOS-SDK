//
//  CreateAccountCreateAccountViewInput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

protocol CreateAccountViewInput: class {
    func setupInitialState(with user: SocialUser)
    
    func setUser(_ user: SocialUser)
    
    func showError(_ error: Error)
    
    func setCreateAccountButtonEnabled(_ isEnabled: Bool)
}
