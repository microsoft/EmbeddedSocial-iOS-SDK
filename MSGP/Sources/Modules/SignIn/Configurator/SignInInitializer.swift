//
//  SignInSignInInitializer.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class SignInModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var signinViewController: SignInViewController!

    override func awakeFromNib() {

        let configurator = SignInModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: signinViewController)
    }

}
