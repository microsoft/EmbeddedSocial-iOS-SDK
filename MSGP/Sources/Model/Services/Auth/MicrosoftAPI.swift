//
//  MicrosoftAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/12/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import MSAL
import MSGraphSDK
import MSGraphSDK_NXOAuth2Adapter

final class MicrosoftAPI: AuthAPI {
    private let clientID = "5e4ecf55-0958-4324-b32a-332e42064697"
    private let scopes = ["https://graph.microsoft.com/User.Read"]
    private let graphClient: MSGraphClient
    
    init() {
        NXOAuth2AuthenticationProvider.setClientId(clientID, scopes: scopes)
        MSGraphClient.setAuthenticationProvider(NXOAuth2AuthenticationProvider.sharedAuth())
        graphClient = MSGraphClient.defaultClient()
    }
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void) {
        guard let application = try? MSALPublicClientApplication(clientId: clientID) else {
            let url = "https://github.com/AzureAD/microsoft-authentication-library-for-objc"
            fatalError("Microsoft ClientId is not set. Please follow instructions from \(url)")
        }
        
        
        NXOAuth2AuthenticationProvider.sharedAuth().login(with: viewController) { error in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
        }
    }
    
    func getUserInfo(handler: @escaping (Result<User>) -> Void) {
        graphClient.me().request().getWithCompletion { (user: MSGraphUser?, error: Error?) in
            let user = User(firstName: user?.givenName,
                            lastName: user?.surname,
                            email: user?.mail,
                            bio: user?.aboutMe,
                            token: nil,
                            photo: nil,
                            provider: .microsoft)
            handler(.success(user))
        }
    }
    
    func disconnect() {
        NXOAuth2AuthenticationProvider.sharedAuth().logout()
    }
}

extension MicrosoftAPI {
    enum APIError: LocalizedError {
        case userInfoLoadFailure
        
        public var errorDescription: String? {
            switch self {
            case .userInfoLoadFailure: return "Failed to load user info."
            }
        }
    }
}
