//
//  CreateAccountViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var userProfilePhoto: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var emailAddressToConfirm: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordToConfirm: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var userBio: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadUserPhoto(sender: UIButton) {
        //upload photo code here (not sure if this is a segue to UploadViewController)
    }

    @IBAction func createNewAccount(sender: UIButton) {
        //create new account
    }

    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
