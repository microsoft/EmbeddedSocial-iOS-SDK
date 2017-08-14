//
//  ReplyCell.swift
//  EmbeddedSocial
//
//  Created by Mac User on 14.08.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {

    static let defaultHeight: CGFloat = 120

    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var replyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
