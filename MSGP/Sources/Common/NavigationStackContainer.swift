//
//  NavigationStackContainer.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import UIKit

class NavigationStackContainer: UIViewController {
    
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
        
        embeddedViewController?.view.removeFromSuperview()
        embeddedViewController?.removeFromParentViewController()
        
        viewController.willMove(toParentViewController: self)
        
        view.addSubview(viewController.view)
        
        viewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        
        embeddedViewController = viewController
    }
}
