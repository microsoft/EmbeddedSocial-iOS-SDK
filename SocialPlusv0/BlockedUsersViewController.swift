//
//  BlockedUsersViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class BlockedUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var blockedUsersTableView: UITableView!
    let customGreenColor = UIColor(red: 75/255, green: 174/255, blue: 79/255, alpha: 1.0).CGColor

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //create ten rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BlockedUserCell") as! BlockedUserCell
        cell.blockUnblockButton.backgroundColor = UIColor.clearColor()
        cell.blockUnblockButton.layer.masksToBounds = true
        cell.blockUnblockButton.layer.cornerRadius = 5
        cell.blockUnblockButton.layer.borderWidth = 1
        cell.blockUnblockButton.layer.borderColor = customGreenColor
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
