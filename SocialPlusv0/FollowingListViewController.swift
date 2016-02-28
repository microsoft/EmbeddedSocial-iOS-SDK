//
//  FollowingListViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class FollowingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var followingTableView: UITableView!
    let customGreenColor = UIColor(red: 75/255, green: 174/255, blue: 79/255, alpha: 1.0).CGColor
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //create ten rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowerCell") as! FollowerCell
        cell.followUnfollowButton.backgroundColor = UIColor.clearColor()
        cell.followUnfollowButton.layer.masksToBounds = true
        cell.followUnfollowButton.layer.cornerRadius = 5
        cell.followUnfollowButton.layer.borderWidth = 1
        cell.followUnfollowButton.layer.borderColor = customGreenColor
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
