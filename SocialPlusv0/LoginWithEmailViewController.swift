//
//  LoginWithEmailViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class LoginWithEmailViewController: UIViewController {

    @IBOutlet weak var userEmailAddress: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        signinButton.layer.cornerRadius = 5
    }

    @IBAction func userForgotPassword(sender: AnyObject) {
        //User forgot password
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func incorrectPasswordAlert(){
        let alertController = UIAlertController(title: "Please try again...", message: "This username and password do not match.", preferredStyle: .Alert)
        
        let confirmPostAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(confirmPostAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
