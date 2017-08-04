//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class FeedModuleRouter: FeedModuleRouterInput {
    
    weak var navigationController: UINavigationController?
    
    func open(route: FeedModuleRoutes) {
        let dummy = UIViewController()
        dummy.title = route.rawValue
        dummy.view = UIView()
        dummy.view.backgroundColor = UIColor.green
        navigationController?.pushViewController(dummy, animated: true)
    }
}
