//
//  ReplyCell.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ReplyCell: UITableViewCell {

    @IBOutlet weak var replierProfilePicture: UIImageView!
    @IBOutlet weak var replierUsername: UIButton!
    
    @IBOutlet weak var timeSinceReplied: UILabel!
    
    @IBOutlet weak var replyTextView: UITextView!
    
    @IBOutlet weak var numLikes: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
