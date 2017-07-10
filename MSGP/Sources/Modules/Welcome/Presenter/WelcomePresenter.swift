//
//  WelcomeWelcomePresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class WelcomePresenter: WelcomeModuleInput, WelcomeViewOutput, WelcomeInteractorOutput {
    
    func signWithTwitter() {
        self.router.openSignIn(with: .Twitter)
    }
    
    func signWithGoogle() {
        self.router.openSignIn(with: .Google)
    }
    
    func signWithEmail() {
        self.router.openSignIn(with: .Email)
    }
    
    func createAccount() {
        self.router.openCreateAccount()
    }
    
    weak var view: WelcomeViewInput!
    var interactor: WelcomeInteractorInput!
    var router: WelcomeRouterInput!

    func viewIsReady() {
        
    }
    
    
}
