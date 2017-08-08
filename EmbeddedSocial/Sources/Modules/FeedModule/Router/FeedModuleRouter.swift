//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class FeedModuleRouter: FeedModuleRouterInput {
    
    weak var navigationController: UINavigationController?
    
    func open(route: FeedModuleRoutes) {
        
        switch route {
        case .profileDetailes(let userHandle):
            
            let configurator = UserProfileConfigurator()
            configurator.configure(userID: userHandle)
            
            navigationController?.pushViewController(configurator.viewController, animated: true)

        default:
            let dummy = UIViewController()
            dummy.view = UIView()
            dummy.view.backgroundColor = UIColor.yellow
            navigationController?.pushViewController(dummy, animated: true)
        }
    }
}
