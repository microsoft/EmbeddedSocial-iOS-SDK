//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol SideMenuRouterInput {
    
    func close()
    func open(_ viewController: UIViewController)
    func openLoginScreen()
    func openMyProfile()
}

protocol SideMenuRouterOutput {
    
}

class SideMenuRouter: SideMenuRouterInput {

    var output: NavigationStackProtocol!
    weak var coordinator: CrossModuleCoordinator!
    
    func close() {
        output.closeMenu()
    }
    
    func open(_ viewController: UIViewController) {
        output.show(viewController)
        close()
    }
    
    func openLoginScreen() {
        let viewController = coordinator.configuredLogin
        output.show(viewController)
        close()
    }
    
    func openMyProfile() {
        let viewController = coordinator.configuredUserProfile
        output.show(viewController)
        close()
    }
}

