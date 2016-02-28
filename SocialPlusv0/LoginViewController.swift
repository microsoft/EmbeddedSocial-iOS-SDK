//
//  ViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if self.revealViewController() != nil {
            let menuButton = UIButton()
            menuButton.frame = CGRectMake(0, 0, 22, 22)
            menuButton.setBackgroundImage(UIImage(named: "icon_hamburger.png"), forState: UIControlState.Normal)
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            hamburgerButton.customView = menuButton
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginWithFB(sender: UIButton) {
        //Facebook login
    }
    
    @IBAction func loginWithTwitter(sender: UIButton) {
        //Twitter login
    }
    
    @IBAction func loginWithMSFT(sender: UIButton) {
        //MSFT login
    }
    
    @IBAction func loginWithGoogle(sender: UIButton) {
        //Google login
    }
    
    @IBAction func loginWithEmail(sender: AnyObject) {
        //Login with email
    }
    
    @IBAction func createNewAccount(sender: AnyObject) {
        //Create new account (not sure if this is just a segue to the CreateAccountViewController)
    }
}

