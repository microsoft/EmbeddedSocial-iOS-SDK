//
//  AuthService.swift
//  SocialPlusv0
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

protocol AuthServiceType {
    func login(email: String, password: String, handler: @escaping (Result<User>) -> Void)
    
    func createAccount(email: String, password: String, handler: @escaping (Result<User>) -> Void)
}

struct AuthService: AuthServiceType {

    func login(email: String, password: String, handler: @escaping (Result<User>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            handler(.success(User(username: email)))
        }
    }
    
    func createAccount(email: String, password: String, handler: @escaping (Result<User>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            handler(.success(User(username: email)))
        }
    }
}
