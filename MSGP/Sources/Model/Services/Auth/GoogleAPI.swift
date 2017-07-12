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
    fileprivate var signInHandler: ((Result<User>) -> Void?)?
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void) {
        signInHandler = handler
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = viewController
        GIDSignIn.sharedInstance().signIn()
    }
}

extension GoogleAPI: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard error == nil else {
            signInHandler?(.failure(error!))
            return
        }
        
        let photoURL = user.profile.imageURL(withDimension: 1024)
        
        let domainUser = User(firstName: user.profile.givenName,
                              lastName: user.profile.familyName,
                              email: user.profile.email,
                              bio: nil,
                              phoneNumber: nil,
                              token: user.authentication.idToken,
                              photo: Photo(url: photoURL?.absoluteString),
                              provider: .google)
        
        signInHandler?(.success(domainUser))
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error?) {
        
    }
}

extension UIViewController: GIDSignInUIDelegate { }
