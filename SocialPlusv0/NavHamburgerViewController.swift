//
//  NavHamburgerViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class NavHamburgerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var hamburgerNavTableView: UITableView!

    var navigationLinkItems = [String]()
    var navigationLinkIcons = [String]()

    @IBAction func myProfileTapped(sender: AnyObject) {
        performSegueWithIdentifier("segueFromNavToMyProfile", sender: self)
    }
    override func viewDidLoad() {
        self.navigationController?.navigationBar.hidden = false
        super.viewDidLoad()
        
        navigationLinkItems = [
            "Home",
            "Search",
            "Popular",
            "My Pins",
            "Activity Feed",
            "Settings",
            "Logout"
        ]
        
        navigationLinkIcons = [
            "icon_home.png",
            "icon_search.png",
            "icon_popular.png",
            "icon_pins.png",
            "icon_activity.png",
            "icon_settings.png",
            "icon_logout.png"
        ]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navigationLinkItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NavigationLinkCell") as! NavigationLinkCell
        
        let cellIcon = UIImage(named: navigationLinkIcons[indexPath.row])
        cell.navigationIcon.image = cellIcon
        cell.navigationLinkLabel.text = navigationLinkItems[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.row){
        case 0:
            performSegueWithIdentifier("segueFromNavToFeed", sender: self)
            break
        case 1:
            performSegueWithIdentifier("segueFromNavToSearch", sender: self)
            break
        case 2:
            performSegueWithIdentifier("segueFromNavToExplore", sender: self)
            break
        case 3:
            performSegueWithIdentifier("segueFromNavToPins", sender: self)
            break
        case 4:
            performSegueWithIdentifier("segueFromNavToActivity", sender: self)
            break
        case 5:
            performSegueWithIdentifier("segueFromNavToSettings", sender: self)
        default:
            break
        }
    }

}
