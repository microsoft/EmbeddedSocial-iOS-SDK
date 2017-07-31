//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class HomeRouter: HomeRouterInput {
    
    weak var viewController: UIViewController?
    
    func open(route: HomeRoutes) {
        let dummy = UIViewController()
        dummy.title = route.rawValue
        viewController?.navigationController?.pushViewController(dummy, animated: true)
    }

}
