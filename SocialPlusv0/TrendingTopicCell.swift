//
//  TrendingTopicCell.swift
//  SocialPlusv0
//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class TrendingTopicCell: UITableViewCell {

    @IBOutlet weak var trendingTopicRankLabel: UILabel!
    @IBOutlet weak var trendingTopicNameLabel: UILabel!
    @IBOutlet weak var trendingTopicNumPostsLabel: UILabel!    
    @IBOutlet weak var trendingTopicIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
