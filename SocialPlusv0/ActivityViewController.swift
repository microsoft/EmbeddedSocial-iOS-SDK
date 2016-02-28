//
//  ActivityViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var activityTableView: UITableView!
    
    @IBOutlet weak var youFollowingSegmentedControl: UISegmentedControl!
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.lightGrayColor()
        header.textLabel!.font = UIFont(name: "HelveticaNeue-Bold",
            size: 12.0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 10
        } else {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell: FollowerRequestCell = tableView.dequeueReusableCellWithIdentifier("FollowerRequestCell") as! FollowerRequestCell
            return cell
        } else {
            let cell: ActivityCell = tableView.dequeueReusableCellWithIdentifier("ActivityCell")as! ActivityCell
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "NEW FOLLOW REQUESTS"
        } else {
            return "RECENT ACTIVITY"
        }
    }

}
