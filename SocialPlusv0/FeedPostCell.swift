//
//  FeedPostCell.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class FeedPostCell: UITableViewCell {

    @IBOutlet weak var userProfileImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var minutesSincePostedLabel: UILabel!
    @IBOutlet weak var postPhotoImage: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDescriptionTextView: UITextView!
    @IBOutlet weak var userOptionsButton: UIButton!
    
    @IBOutlet weak var appIconPostedFromButton: UIButton! //make this a button so that you can click on it to see all posts from this app?
    @IBOutlet weak var appNamePostedFromLabel: UILabel!
    
    @IBOutlet weak var peopleWhoLikedPostLabel: UILabel!

    @IBOutlet weak var numLikesButton: UIButton!
    @IBOutlet weak var numCommentsButton: UIButton!
    
    //TODO: IBOutlets/IBActions for like, comment, and pin posts icons
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
