//
//  CreateAccountCreateAccountInitializer.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class CreateAccountModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var createaccountViewController: CreateAccountViewController!

    override func awakeFromNib() {

        let configurator = CreateAccountModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: createaccountViewController)
    }

}
