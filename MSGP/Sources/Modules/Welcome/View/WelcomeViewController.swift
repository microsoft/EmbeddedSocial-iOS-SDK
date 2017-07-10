//
//  WelcomeWelcomeViewController.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, WelcomeViewInput {

    var output: WelcomeViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    // MARK: WelcomeViewInput
    func setupInitialState() {
        
    }
    
    @IBAction func onTapSignViaTwitter() {
        self.output.signWithTwitter()
    }
    
    @IBAction func onTapSignViaGoogle() {
        self.output.signWithGoogle()
    }
    
    @IBAction func onTapSignViaMail() {
        self.output.signWithEmail()
    }
    
    @IBAction func onTapCreateAccount() {
        self.output.createAccount()
    }
    
    
}
