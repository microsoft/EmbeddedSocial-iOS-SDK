//
//  MenuMenuInitializer.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class MenuModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var menuViewController: MenuViewController!

    override func awakeFromNib() {

        let configurator = MenuModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: menuViewController)
    }

}
