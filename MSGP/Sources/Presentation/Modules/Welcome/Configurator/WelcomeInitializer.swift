//
//  WelcomeWelcomeInitializer.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class WelcomeModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var welcomeViewController: WelcomeViewController!

    override func awakeFromNib() {

        let configurator = WelcomeModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: welcomeViewController)
    }

}
