//
//  PostViewController.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var postTableView: UITableView!
    
    @IBOutlet weak var userPostedProfilePicture: UIButton!
    @IBOutlet weak var userPostedUsername: UILabel!
    
    @IBOutlet weak var timeSincePosted: UILabel!
    
    @IBOutlet weak var postHeroImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    
    @IBOutlet weak var appPostedFromIcon: UIButton!
    @IBOutlet weak var appPostedFromName: UILabel!
    
    @IBOutlet weak var peopleWhoLikedPost: UILabel!
    
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var numPosts: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    //no iboutlets for liked, comment, pin icon yet
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCellWithIdentifier("CommentTableViewCell") as! CommentTableViewCell
        cell.numReplies.layer.cornerRadius = 5
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
