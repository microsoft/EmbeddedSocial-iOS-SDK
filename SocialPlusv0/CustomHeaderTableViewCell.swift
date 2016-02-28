//
//  CustomHeaderTableViewCell.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CustomHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var customHeaderArrowIcon: UIImageView!
    @IBOutlet weak var customHeaderSeeAllButton: UIButton!
    @IBOutlet weak var customHeaderTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
