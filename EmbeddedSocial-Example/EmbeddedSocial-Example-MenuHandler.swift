//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import EmbeddedSocial

class MyAppMenu: SideMenuItemsProvider {
    
//    static var nav: UINavigationController?

    func destination(forItem index: Int) -> UIViewController {
        let vc = UIViewController()
        
        
//        let nav = UINavigationController(rootViewController: vc)
    
        vc.view = UIView()
        vc.view.backgroundColor = index == 0 ? UIColor.red : UIColor.yellow
        vc.title = "Title \(index)"
        
//        nav.pushViewController(blueVC, animated: false)
        
        
        return vc
    }
    
    lazy var blueVC: UIViewController = {
       let vc = UIViewController()
        vc.view = UIView()
        vc.view.backgroundColor = UIColor.blue
        return vc
    }()
    
    var images = ["icon_comment", "icon_liked"]
    var items = ["Screen #1", "Screen #2"]
    
    // MARK: Protocol
    
    func title(forItem index: Int) -> String {
        return items[index]
    }
    
    func image(forItem index: Int) -> UIImage {
        return UIImage(named: images[index])!
    }
    
    func numberOfItems() -> Int {
        return items.count
    }

    func accountImage() -> UIImage? {
        return nil
    }
    
    func accountName() -> String? {
        return nil
    }

    func accountHeaderAvailable() -> Bool {
        return false
    }
    
}

