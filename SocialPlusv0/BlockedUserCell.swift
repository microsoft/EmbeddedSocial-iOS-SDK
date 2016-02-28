//
//  BlockedUserCell.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class BlockedUserCell: UITableViewCell {

    @IBOutlet weak var blockedUserProfilePicture: UIImageView!
    @IBOutlet weak var blockedUsername: UILabel!
    @IBOutlet weak var blockUnblockButton: UIButton!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
