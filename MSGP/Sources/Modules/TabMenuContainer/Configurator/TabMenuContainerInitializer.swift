//
//  TabMenuContainerTabMenuContainerInitializer.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class TabMenuContainerModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var tabmenucontainerViewController: TabMenuContainerViewController!

    override func awakeFromNib() {

        let configurator = TabMenuContainerModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: tabmenucontainerViewController)
    }

}
