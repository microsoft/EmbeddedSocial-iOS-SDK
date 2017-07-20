//
//  CrossModuleCoordinator.swift
//  MSGP
//
//  Created by Igor Popov on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

class CrossModuleCoordinator {
  
    weak var menuModule: SideMenuModuleInput!
    weak var socialPlus: SocialPlus!

}

extension CrossModuleCoordinator: LoginModuleOutput {
    
    func onSessionCreated(user: User, sessionToken: String) {
        self.socialPlus.modelStack = ModelStack(user: user, sessionToken: sessionToken)
        self.menuModule.showUser(user: user)
        
        let nextVC = UIViewController()
        nextVC.view.backgroundColor = UIColor.green
        
        self.menuModule.open(viewController: nextVC)
    }
    
}
