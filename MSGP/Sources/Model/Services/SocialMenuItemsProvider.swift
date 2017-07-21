//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SocialMenuItemsProvider: SideMenuItemsProvider {
    private weak var coordinator: CrossModuleCoordinator!
    private weak var loginHandler: LoginModuleOutput!
    
    private let isUserLoggedIn: Bool
    
    init(coordinator: CrossModuleCoordinator,
         loginHandler: LoginModuleOutput,
         isUserLoggedIn: Bool) {
        self.coordinator = coordinator
        self.loginHandler = loginHandler
        self.isUserLoggedIn = isUserLoggedIn
    }
    
    enum State: Int {
        case authenticated, unauthenticated
    }
    
    enum Route: Int {
        case home, signin
    }
    
    var state: State {
        return isUserLoggedIn ? .authenticated : .unauthenticated
    }
    
    var items = [
        State.authenticated: [(title: "Home", image: UIImage(asset: Asset.iconLiked)),
                              (title: "Sign In", image: UIImage(asset: Asset.iconLiked)),
                              (title: "Search", image: UIImage(asset: Asset.iconSearch)),
                              (title: "Popular", image: UIImage(asset: Asset.iconPopular)),
                              (title: "My pins", image: UIImage(asset: Asset.iconPins)),
                              (title: "Activity Feed", image: UIImage(asset: Asset.iconActivity)),
                              (title: "Settings", image: UIImage(asset: Asset.iconSettings)),
                              (title: "Log out", image: UIImage(asset: Asset.iconLogout))],
        State.unauthenticated: [(title: "Popular", image: UIImage(asset: Asset.iconPopular)),
                                (title: "Sign In", image: UIImage(asset: Asset.iconLiked))
        ]
    ]
    
    func numberOfItems() -> Int {
        return items[state]!.count
    }
    
    func image(forItem index: Int) -> UIImage {
        return items[state]![index].image
    }
    
    func title(forItem index: Int) -> String {
        return items[state]![index].title
    }
    
    func destination(forItem index: Int) -> UIViewController {
        guard let route = Route(rawValue: index) else {
            return UIViewController()
        }
        
        var destinationVC: UIViewController?
        
        switch route {
        case .home:
            destinationVC = UIViewController()
            destinationVC?.view.backgroundColor = .purple
            
        case .signin:
            let loginModule = LoginConfigurator()
            loginModule.configure(moduleOutput: loginHandler)
            destinationVC = loginModule.viewController
        }
        
        return destinationVC!
    }
}
