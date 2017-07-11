//
//  AuthService.swift
//  SocialPlusv0
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

enum AuthProvider: Int {
    case facebook
    case microsoft
    case google
    case twitter
    case email
}

protocol AuthAPI {
    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void)
}

protocol AuthServiceType {
    func login(provider: AuthProvider, from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void)
    
    func login(email: String, password: String, handler: @escaping (Result<User>) -> Void)
    
    func createAccount(email: String, password: String, handler: @escaping (Result<User>) -> Void)
}

protocol AuthAPIProviderType {
    func api(for provider: AuthProvider) -> AuthAPI
}
