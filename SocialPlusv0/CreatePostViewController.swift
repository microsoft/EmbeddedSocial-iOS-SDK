//
//  PostViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var newPostPhoto: UIImageView!
    @IBOutlet weak var newPostTitleField: UITextField!
    @IBOutlet weak var newPostDescriptionField: UITextView!
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createPostAlert(){
        let alertController = UIAlertController(title: "Publish post?", message: "Publishing this post will allow others following you or the Fresh Paint app to see it in their feed.", preferredStyle: .Alert)
        
        let cancelPostAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelPostAction)
        
        let confirmPostAction = UIAlertAction(title: "Publish", style: .Default, handler: nil)
        alertController.addAction(confirmPostAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelPostAlert(){
        let alertController = UIAlertController(title: "Return to feed?", message: "Going back to the feed will delete the content of this draft, are you sure you want to go back?", preferredStyle: .Alert)
        
        let cancelPostAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelPostAction)
        
        let confirmPostAction = UIAlertAction(title: "Publish", style: .Default, handler: nil)
        alertController.addAction(confirmPostAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
}
