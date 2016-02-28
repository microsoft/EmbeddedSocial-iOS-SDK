//
//  ProfileViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var userOptionsButton: UIButton!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userTagline: UITextView!
    
    @IBOutlet weak var numFollowers: UIButton!
    @IBOutlet weak var numFollowing: UIButton!
    @IBOutlet weak var followingStatus: UIButton! //Follow, Pending, Following
    
    @IBOutlet weak var recentPopularSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followingStatus.layer.cornerRadius = 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCellWithIdentifier("FeedPostCell") as! FeedPostCell
        return cell
    }

    @IBAction func userOptionsTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("segueFromProfileToReportIssue", sender: self)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
