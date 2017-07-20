//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol RootRouterProtocol {
    func openLoginScreen()
    
    func openHomeScreen(user: User)
}

final class RootRouter: RootRouterProtocol {
    
    private let window: UIWindow
    
    var onSessionCreated: ((User, String) -> Void)?
    
    private let rootVC: UINavigationController = {
        let nc = UINavigationController()
        nc.navigationBar.isTranslucent = false
        return nc
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func openLoginScreen() {
        let login = LoginConfigurator()
        login.configure(moduleOutput: self)
        
        
        setRootViewController(login.viewController)
    }
    
    func openHomeScreen(user: User) {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.title = "Home"
        setRootViewController(vc)
    }
    
    private func setRootViewController(_ vc: UIViewController) {
        rootVC.viewControllers = [vc]
        window.rootViewController = rootVC
    }
}

extension RootRouter: LoginModuleOutput {
    func onSessionCreated(user: User, sessionToken: String) {
        onSessionCreated?(user, sessionToken)
    }
}
