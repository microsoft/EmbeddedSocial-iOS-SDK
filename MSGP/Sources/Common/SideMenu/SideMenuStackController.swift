//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import SlideMenuControllerSwift

protocol SideMenuStackControllerProtocol {
    
    func closeSideMenu()
    func openSideMenu()
    
}

@objc class MenuStackController: SlideMenuController, SideMenuStackControllerProtocol {
    
    func closeSideMenu() {
        closeLeft()
    }
    
    func openSideMenu() {
        openLeft()
    }
    
}
