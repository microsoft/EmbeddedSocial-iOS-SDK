//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
    
    func logOut() {
        loginManager.logOut()
    }
    
    private func makeSocialUser(json: Any?, token: String) -> SocialUser? {
        guard let json = json as? [String: Any],
            let uid = json["id"] as? String
            else {
                return nil
        }
        
        return SocialUser(credentials: CredentialsList(provider: .facebook, accessToken: token, socialUID: uid),
                   firstName: json["first_name"] as? String,
                   lastName: json["last_name"] as? String,
                   email: json["email"] as? String,
                   photo: makePhoto(json: json["picture"]))
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
