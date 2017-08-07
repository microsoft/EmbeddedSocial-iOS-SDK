//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class SideMenuRouter: SideMenuRouterInput {

    var output: NavigationStackProtocol!
    weak var coordinator: CrossModuleCoordinator!
    
    func close() {
        output.closeMenu()
    }
    
    func open(viewController: UIViewController, sender: Any?) {
        output.show(viewController)
        close()
    }
    
    func openLoginScreen() {
        coordinator.openLoginScreen()
        close()
    }
    
    func openMyProfile() {
        coordinator.openMyProfile()
        close()
    }
}

