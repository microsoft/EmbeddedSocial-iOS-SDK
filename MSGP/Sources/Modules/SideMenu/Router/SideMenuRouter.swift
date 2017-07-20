//
//  SideMenuSideMenuRouter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class SideMenuRouter: SideMenuRouterInput {
    
    var output: SideMenuModuleOutput!
    
    func open(viewController: UIViewController, sender: Any?) {
        
        UIApplication.shared.sendAction(Selector(("closeSideMenu")), to: nil, from: sender, for: nil)
        output.show(viewController: viewController)
    }
    
}

