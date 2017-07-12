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
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void) {
        loginManager.logIn(withReadPermissions: readPermissions, from: viewController) { (result, error) in
            guard error == nil else {
                print(error!)
                handler(.failure(error!))
                return
            }
            
            guard let result = result else {
                fatalError("Unknown result. Please investigate this case and provide proper handling.")
            }
            
            guard !result.isCancelled else {
                print("cancelled")
                return
            }
            
            guard FBSDKAccessToken.current() != nil else {
                fatalError("Trying to fetch user data while not being logged in")
            }
            
            print("Logged in")

            FBSDKGraphRequest(graphPath: "me", parameters: nil).start { (connection, user, error) in
                print(error, user)
            }
        }
    }
}
