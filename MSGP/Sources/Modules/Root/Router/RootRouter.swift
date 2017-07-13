//
//  RootRouter.swift
//  SocialPlusv0
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import UIKit

protocol RootRouterProtocol {
    func openLoginScreen()
    
    func openHomeScreen(user: User)
}

final class RootRouter: RootRouterProtocol {
    
    private let window: UIWindow
    
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

    }
    
    private func setRootViewController(_ vc: UIViewController) {
        rootVC.viewControllers = [vc]
        window.rootViewController = rootVC
    }
}

extension RootRouter: LoginModuleOutput {
    func onLogin(_ user: User) {
        openHomeScreen(user: user)
    }
}
