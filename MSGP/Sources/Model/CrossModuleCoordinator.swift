//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
