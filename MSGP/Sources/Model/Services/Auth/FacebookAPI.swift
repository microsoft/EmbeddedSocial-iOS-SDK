//
//  FacebookAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

final class FacebookAPI: AuthAPI {
    private let loginManager = FBSDKLoginManager()
    
    private let readPermissions = ["public_profile", "email"]
    
    private let userInfoParams = ["fields": "first_name, last_name, email, picture"]
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        
        loginManager.logIn(withReadPermissions: readPermissions, from: viewController) { [unowned self] result, error in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            
            guard let result = result else {
                fatalError("Unknown result. Please investigate this case and provide proper handling.")
            }
            
            guard !result.isCancelled else {
                handler(.failure(APIError.cancelled))
                return
            }
            
            FBSDKGraphRequest(graphPath: "me", parameters: self.userInfoParams).start { _, userJSON, _ in
                guard let user = self.makeSocialUser(json: userJSON, token: result.token.tokenString) else {
                    handler(.failure(APIError.missingUserData))
                    return
                }
                handler(.success(user))
            }
        }
    }
    
    private func makeSocialUser(json: Any?, token: String) -> SocialUser? {
        guard let json = json as? [String: Any],
            let uid = json["id"] as? String
            else {
                return nil
        }
        
        return SocialUser(uid: uid,
                          token: token,
                          firstName: json["first_name"] as? String,
                          lastName: json["last_name"] as? String,
                          email: json["email"] as? String,
                          photo: makePhoto(json: json["picture"]),
                          provider: .facebook)
    }
    
    private func makePhoto(json: Any?) -> Photo? {
        guard let json = json as? [String: Any],
            let metadata = json["data"] as? [String: Any],
            let url = metadata["url"] as? String else {
                return nil
        }
        
        return Photo(url: url)
    }
}

extension FacebookAPI {
    
    enum APIError: LocalizedError {
        case cancelled
        case missingUserData

        public var errorDescription: String? {
            switch self {
            case .cancelled: return "Cancelled by user."
            case .missingUserData: return "User data is missing."
            }
        }
    }
}
