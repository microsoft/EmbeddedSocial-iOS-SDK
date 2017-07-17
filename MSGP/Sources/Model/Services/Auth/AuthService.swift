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
    
    static let all: [AuthProvider] = [.facebook, .microsoft, .google, .twitter]
}

extension AuthProvider {
    var name: String {
        return ["Facebook", "Microsoft", "Google", "Twitter"][self.rawValue]
    }
    
    func authHeader(for user: SocialUser) -> String {
        switch self {
        case .facebook, .google, .microsoft:
            return String(format: apiTemplate, name, Constants.appKey, user.token)
        case .twitter where user.requestToken != nil:
            return String(format: apiTemplate, name, Constants.appKey, user.requestToken!, user.token)
        default:
            fatalError("Twitter requestToken is missing or auth provider is not supported")
        }
    }
    
    private var apiTemplate: String {
        switch self {
        case .facebook, .google, .microsoft:
            return "%@ AK=%@|TK=%@"
        case .twitter:
            return "%@ AK=%@|RT=%@|TK=%@"
        }
    }
}

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
