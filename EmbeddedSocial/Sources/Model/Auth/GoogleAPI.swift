//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import GoogleSignIn

final class GoogleAPI: NSObject, AuthAPI {
    fileprivate let profileImageDimensionPx: UInt = 256
    
    fileprivate var signInHandler: ((Result<SocialUser>) -> Void?)?
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        signInHandler = handler
        
        // force sign in dialogue
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signOut()
        }
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = viewController
        GIDSignIn.sharedInstance().signIn()
    }
}

extension GoogleAPI: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            signInHandler?(.failure(error!))
            return
        }
        //FIXME: Use proper value for image dimension
        let photoURL = user.profile.imageURL(withDimension: profileImageDimensionPx)
        
        let credentials = CredentialsList(provider: .google, accessToken: user.authentication.accessToken, socialUID: user.userID)
        let user = SocialUser(credentials: credentials,
                   firstName: user.profile.givenName,
                   lastName: user.profile.familyName,
                   email: user.profile.email,
                   photo: Photo(url: photoURL?.absoluteString))
        
        signInHandler?(.success(user))
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

extension UIViewController: GIDSignInUIDelegate { }
