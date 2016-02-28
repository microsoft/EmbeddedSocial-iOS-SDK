//
//  MyProfileViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class MyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var myProfileTableView: UITableView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var toggleGalleryListButton: UIBarButtonItem!
    
    @IBOutlet weak var userProfilePhotoButton: UIButton!
    @IBOutlet weak var myUsername: UILabel!
    @IBOutlet weak var myTagline: UITextView!
    
    @IBOutlet weak var numFollowersButton: UIButton!
    @IBOutlet weak var numFollowingButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var recentPopularSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if self.revealViewController() != nil {
            let menuButton = UIButton()
            menuButton.frame = CGRectMake(0, 0, 24, 24)
            menuButton.setBackgroundImage(UIImage(named: "icon_hamburger.png"), forState: UIControlState.Normal)
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            
            hamburgerButton.customView = menuButton
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let toggleViewButton = UIButton()
        toggleViewButton.frame = CGRectMake(0, 0, 24, 24)
        toggleViewButton.setBackgroundImage(UIImage(named: "icon_gallery.png"), forState: UIControlState.Normal)
        //Do something to switch between list and gallery view and change the background image
        
        toggleGalleryListButton.customView = toggleViewButton

    }
  
    
    @IBAction func editPhoto(sender: AnyObject) {
        userProfilePhotoButton.addTarget(self, action: "showUploadPhotoActionSheet", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func showUploadPhotoActionSheet() {
        let userOptionsActionSheet: UIAlertController = UIAlertController(title:"Change Profile Picture", message:nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        userOptionsActionSheet.addAction(UIAlertAction(title:"Remove Current Photo", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Remove Current Photo")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Take Photo", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Take Photo")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Choose from Library", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Choose from Library")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        
        presentViewController(userOptionsActionSheet, animated:true, completion:nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myProfileTableView.dequeueReusableCellWithIdentifier("FeedPostCell") as! FeedPostCell
        cell.userOptionsButton.addTarget(self, action: "showActionSheet", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func showActionSheet() {
        let userOptionsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        userOptionsActionSheet.addAction(UIAlertAction(title:"Edit post", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Edit post")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Delete post", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Delete post")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        
        presentViewController(userOptionsActionSheet, animated:true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
