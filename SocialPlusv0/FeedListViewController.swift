//
//  FeedViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class FeedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var toggleGalleryListButton: UIBarButtonItem!
    var refreshControl: UIRefreshControl!
    
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
        toggleGalleryListButton.customView = toggleViewButton
        
        //Pull to refresh: http://www.andrewcbancroft.com/2015/03/17/basics-of-pull-to-refresh-for-swift-developers/
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl.backgroundColor = UIColor.blackColor()
//        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
//        self.feedTableView.addSubview(self.refreshControl)
//        
//        func refresh(sender:AnyObject){
//            println("refreshed")
//        }
        
        //Do something here to switch between list and gallery view and change the background image to "icon_gallery.png"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 5
        } else {
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedPostCell") as! FeedPostCell
        cell.userOptionsButton.addTarget(self, action: "showActionSheet", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func showActionSheet() {
        let userOptionsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        userOptionsActionSheet.addAction(UIAlertAction(title:"Hide post", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Unfollow user")}))
        
        //"Unfollow this user should change to "Unfollow this app"
        userOptionsActionSheet.addAction(UIAlertAction(title:"Unfollow this user", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Block user")}))
        userOptionsActionSheet.addAction(UIAlertAction(title:"Report post", style:UIAlertActionStyle.Default, handler:{ (alert: UIAlertAction) -> Void in print("Report post")}))
        
        userOptionsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        
        presentViewController(userOptionsActionSheet, animated:true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

