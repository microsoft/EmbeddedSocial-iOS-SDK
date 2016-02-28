//
//  RepliesViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class RepliesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var replyTableView: UITableView!
    
    @IBOutlet weak var commenterProfilePicture: UIImageView!
    @IBOutlet weak var commenterUsername: UIButton!
    
    @IBOutlet weak var timeSincePosted: UILabel!
    
    @IBOutlet weak var numLikes: UIButton!
    
    @IBOutlet weak var replyToPostTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = replyTableView.dequeueReusableCellWithIdentifier("ReplyCell") as! ReplyCell
        return cell
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
