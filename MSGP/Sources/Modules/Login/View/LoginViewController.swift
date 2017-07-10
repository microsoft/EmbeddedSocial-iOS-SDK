//
//  LoginLoginViewController.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInput {
    
    @IBOutlet fileprivate weak var facebookButton: UIButton!
    @IBOutlet fileprivate weak var twitterButton: UIButton!
    @IBOutlet fileprivate weak var microsoftButton: UIButton!
    @IBOutlet fileprivate weak var googleButton: UIButton!
    
    @IBOutlet fileprivate weak var emailSignInButton: UIButton!
    @IBOutlet fileprivate weak var createAccountButton: UIButton!
    
    var output: LoginViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    func setupInitialState() {
        for button in [facebookButton, twitterButton, microsoftButton, googleButton] {
            button?.setTitleColor(Palette.darkGrey, for: .normal)
            button?.titleLabel?.font = Fonts.regular
        }
        
        for button in [emailSignInButton, createAccountButton] {
            button?.setTitleColor(Palette.green, for: .normal)
            button?.titleLabel?.font = Fonts.small
        }
    }
    
    @IBAction fileprivate func onCreateAccount(_ sender: UIButton) {
        output.onCreateAccountTapped()
    }
    
    @IBAction fileprivate func onEmailSignIn(_ sender: UIButton) {
        output.onEmailSignInTapped()
    }
    
    @IBAction fileprivate func onFacebookSignIn(_ sender: UIButton) {
        output.onFacebookSignInTapped()
    }
    
    @IBAction fileprivate func onTwitterSignIn(_ sender: UIButton) {
        output.onTwitterSignInTapped()
    }
    
    @IBAction fileprivate func onMicrosoftSignIn(_ sender: UIButton) {
        output.onMicrosoftSignInTapped()
    }
    
    @IBAction fileprivate func onGooglePlusSignIn(_ sender: UIButton) {
        output.onGoogleSignInTapped()
    }
}
