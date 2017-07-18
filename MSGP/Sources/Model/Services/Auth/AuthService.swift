//
//  AuthService.swift
//  SocialPlusv0
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

protocol AuthAPI {
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void)
}

protocol AuthServiceType {
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               handler: @escaping (Result<SocialUser>) -> Void)
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<User>) -> Void)
}

protocol AuthAPIProviderType {
    func api(for provider: AuthProvider) -> AuthAPI
}
