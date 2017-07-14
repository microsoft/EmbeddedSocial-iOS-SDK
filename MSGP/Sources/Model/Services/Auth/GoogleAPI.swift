//
//  GoogleAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit
import GoogleSignIn

final class GoogleAPI: NSObject, AuthAPI {
    fileprivate var signInHandler: ((Result<SocialUser>) -> Void?)?
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        signInHandler = handler
        
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
        let photoURL = user.profile.imageURL(withDimension: 256)
        
        let user = SocialUser(uid: user.userID,
                              token: user.authentication.idToken,
                              firstName: user.profile.givenName,
                              lastName: user.profile.familyName,
                              email: user.profile.email,
                              photo: Photo(url: photoURL?.absoluteString),
                              provider: .google)
        
        signInHandler?(.success(user))
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

extension UIViewController: GIDSignInUIDelegate { }
