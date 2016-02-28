//
//  SearchViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating{

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var toggleListGalleryButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    let customGreenColor = UIColor(red: 75/255, green: 174/255, blue: 79/255, alpha: 1.0).CGColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        
        if self.revealViewController() != nil {
            let menuButton = UIButton()
            menuButton.frame = CGRectMake(0, 0, 24, 24)
            menuButton.setBackgroundImage(UIImage(named: "icon_hamburger.png"), forState: UIControlState.Normal)
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            
            hamburgerButton.customView = menuButton
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let toggleListGallery = UIButton()
        toggleListGallery.frame = CGRectMake(0, 0, 24, 24)
        toggleListGallery.setBackgroundImage(UIImage(named: "icon_gallery.png"), forState:UIControlState.Normal)
        toggleListGalleryButton.customView = toggleListGallery
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //implement with scope bar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchTableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //check to see if people or topics then return the appropriate cell 
        //recommended users (when people toggled and search is not active) & search results for people use the FollowerCell (has the follow/unfollow button)
        //if people toggled and search is active but user has not entered text, then most recent people search shows up 
        //if people toggled and search is active and user has entered text, then can use FollowerCell but hide the follow/unfollow button
        let cell = searchTableView.dequeueReusableCellWithIdentifier("FollowerCell", forIndexPath: indexPath) as! FollowerCell
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
