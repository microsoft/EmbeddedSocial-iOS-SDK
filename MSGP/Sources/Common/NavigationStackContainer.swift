//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class NavigationStackContainer: UIViewController, SideMenuModuleOutput {
    
    var embeddedViewController: UIViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set menu button
        
        let image = UIImage(named: "icon_hamburger", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        self.addLeftBarButtonWithImage(image)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func show(viewController: UIViewController) {
        
        self.navigationController?.pushViewController(viewController, animated: true)
    
        return
//        embeddedViewController?.view.removeFromSuperview()
//        embeddedViewController?.removeFromParentViewController()
//        
//        viewController.willMove(toParentViewController: self)
//        self.addChildViewController(viewController)
//        
//        view.addSubview(viewController.view)
//        
//        viewController.view.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//        
//        viewController.didMove(toParentViewController: self)
//        
//        embeddedViewController = viewController
    }
}
