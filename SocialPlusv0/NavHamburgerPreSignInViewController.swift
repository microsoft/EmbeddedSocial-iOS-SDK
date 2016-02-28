//
//  NavHamburgerPreSignInViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class NavHamburgerPreSignInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var hamburgerNavTableView: UITableView!
    
    var navigationLinkItems = [String]()
    var navigationLinkIcons = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //modify for non signed in hamburger
        
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
        cell.navigationLinkLabel.text = navigationLinkItems[indexPath.row]
        cell.navigationIcon.image = cellIcon
        return cell
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
