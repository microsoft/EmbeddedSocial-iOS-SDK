//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class SideMenuRouter: SideMenuRouterInput {
    
    var output: SideMenuModuleOutput!
    
    func open(viewController: UIViewController, sender: Any?) {
        
        UIApplication.shared.sendAction(Selector(("closeSideMenu")), to: nil, from: sender, for: nil)
        output.show(viewController: viewController)
    }
    
}

