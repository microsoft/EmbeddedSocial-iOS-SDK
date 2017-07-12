//
//  NavigationStackContainer.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import UIKit

class NavigationStackContainer: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set menu button
        
        let image = UIImage(named: "icon_hamburger", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        self.addLeftBarButtonWithImage(image)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        
    }
    
}
