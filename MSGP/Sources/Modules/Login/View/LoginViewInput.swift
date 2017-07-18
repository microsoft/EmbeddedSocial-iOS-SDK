//
//  LoginLoginViewInput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

protocol LoginViewInput: class {
    func setupInitialState()
    
    func showError(_ error: Error)
    
    func setIsLoading(_ isLoading: Bool)
}
