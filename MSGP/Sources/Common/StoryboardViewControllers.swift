//
//  StoryboardViewControllers.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

extension Storyboard {
    
    static let createAccount = CreateAccount()
    
    struct CreateAccount: StoryboardResourceWithInitialControllerType {
        typealias InitialController = CreateAccountViewController
        
        let bundle = Bundle(for: Storyboard.self)
        let createAccountViewController =
            StoryboardViewControllerResource<CreateAccountViewController>(identifier: "CreateAccountViewController")
        let name = "CreateAccount"
        
        func createAccountViewController(_: Void = ()) -> CreateAccountViewController? {
            return UIStoryboard(resource: self).instantiateViewController(withResource: createAccountViewController)
        }
        
        fileprivate init() {}
    }
}

extension Storyboard {
    
    static let login = Login()
    
    struct Login: StoryboardResourceWithInitialControllerType {
        typealias InitialController = LoginViewController
        
        let bundle = Bundle(for: Storyboard.self)
        let loginViewController =
            StoryboardViewControllerResource<LoginViewController>(identifier: "LoginViewController")
        let name = "Login"
        
        func loginViewController(_: Void = ()) -> LoginViewController? {
            return UIStoryboard(resource: self).instantiateViewController(withResource: loginViewController)
        }
        
        fileprivate init() {}
    }
}
