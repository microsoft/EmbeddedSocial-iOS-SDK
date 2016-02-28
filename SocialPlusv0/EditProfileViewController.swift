//
//  ProfileViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var userPhoto: UIButton! 
    @IBOutlet weak var editPhotoTextButton: UIButton!
    
    @IBOutlet weak var userRealName: UITextField!
    @IBOutlet weak var userEmailAddress: UITextField!
    @IBOutlet weak var userPhoneNumber: UITextField!
    @IBOutlet weak var userBio: UITextView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func editPhoto(sender: AnyObject) {
        //edit photo
      editPhotoTextButton.addTarget(self, action: "showActionSheet", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func showActionSheet() {
        let userOptionsActionSheet: UIAlertController = UIAlertController(title:"Change Profile Picture", message:nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        userOptionsActionSheet.addAction(UIAlertAction(title:"Remove Current Photo", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Remove Current Photo")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Take Photo", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Take Photo")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Choose from Library", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Choose from Library")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        
        presentViewController(userOptionsActionSheet, animated:true, completion:nil)
    }
    
    
    @IBAction func saveChanges(sender: AnyObject) {
        //save changes
        print("save changes pressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
