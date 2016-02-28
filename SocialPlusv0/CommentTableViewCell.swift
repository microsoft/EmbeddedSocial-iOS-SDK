//
//  CommentTableViewCell.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commenterProfileImage: UIImageView!
    @IBOutlet weak var commenterUsername: UIButton!
    @IBOutlet weak var commentOptions: UIButton!

    @IBOutlet weak var timeSinceCommented: UILabel!
    @IBOutlet weak var commentDescription: UITextView!
    
    @IBOutlet weak var userLikedButton: UIButton!
    @IBOutlet weak var userCommentedButton: UIButton!
    
    @IBOutlet weak var numLikes: UIButton!
    @IBOutlet weak var numReplies: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
