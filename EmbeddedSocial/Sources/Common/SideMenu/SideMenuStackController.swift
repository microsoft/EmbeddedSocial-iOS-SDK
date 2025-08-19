//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SlideMenuControllerSwift

protocol SideMenuStackControllerProtocol {
    func closeSideMenu()
    func openSideMenu()
}

protocol MenuStackControllerDelegate {
    func menuWillOpen()
    func menuDidOpen()
}

class MenuStackController: SideMenuStackControllerProtocol, SlideMenuControllerDelegate {
    
    private(set) var slideMenuVC: SlideMenuController
    var delegate: MenuStackControllerDelegate?
    
    init(containerVC: UIViewController, menuVC: UIViewController, delegate: MenuStackControllerDelegate? = nil) {
        self.slideMenuVC = SlideMenuController(mainViewController: containerVC, leftMenuViewController: menuVC)
    }
    
    func closeSideMenu() {
        slideMenuVC.closeLeft()
    }
    
    func openSideMenu() {
        slideMenuVC.openLeft()
    }
    
    // MARK: SlideMenuController Delegate
    
    @objc func leftWillOpen() {
        delegate?.menuWillOpen()
    }
    
    @objc func leftDidOpen() {
        delegate?.menuDidOpen()
    }
}
