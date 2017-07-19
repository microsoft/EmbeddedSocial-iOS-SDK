//
//  MSGP-Example-MenuHandler.swift
//  MSGP-Example
//
//  Created by Igor Popov on 7/13/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import MSGP

class MyAppMenu: SideMenuItemsProvider {

    func destination(forItem index: Int) -> UIViewController {
        let vc = UIViewController()
        
        vc.view = UIView()
        vc.view.backgroundColor = index == 0 ? UIColor.red : UIColor.yellow
        vc.title = "Title \(index)"
        
        return vc
    }
    
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

