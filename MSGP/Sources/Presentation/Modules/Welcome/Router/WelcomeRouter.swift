//
//  WelcomeWelcomeRouter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class WelcomeRouter: WelcomeRouterInput {
    
    func openSignIn(with: SignInType) {
        
        /*
         
         a) if we use segues here, logic will be shared between two modules view controllers and router.
         b) ideal solution here is to connect Source Module Router with Destination Module Presenter
         
         */
        
        let sb = UIStoryboard(name: "SignIn", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        
        
        
        
    }
    
    func openCreateAccount() {
        
    }
    

}
