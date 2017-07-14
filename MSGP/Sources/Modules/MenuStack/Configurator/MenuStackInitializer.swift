//
//  MenuStackMenuStackInitializer.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class MenuStackModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var menustackViewController: MenuStackViewController!

    override func awakeFromNib() {

        let configurator = MenuStackModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: menustackViewController)
    }

}
