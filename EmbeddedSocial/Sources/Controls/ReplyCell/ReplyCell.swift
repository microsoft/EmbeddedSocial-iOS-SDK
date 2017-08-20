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

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var totalLikesButton: UIButton!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var replyLabel: UILabel!
    
    var replyView: ReplyViewModel!
    
    private var formatter = DateFormatterTool()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(replyView: ReplyViewModel) {
        self.replyView = replyView
        avatarButton.setPhotoWithCaching(Photo(uid: UUID().uuidString,
                                               url: replyView.userImageUrl,
                                               image: nil),
                                         placeholder: UIImage(asset: .userPhotoPlaceholder))

        totalLikesButton.setTitle(replyView.totalLikes, for: .normal)
        replyLabel.text = replyView.text
        usernameLabel.text = replyView.userName
        
        postTimeLabel.text = replyView.timeCreated
        likeButton.isSelected = replyView.isLiked
        selectionStyle = .none
        contentView.layoutIfNeeded()
    }
    
    @IBAction func like(_ sender: Any) {
        replyView.onAction?(.like, tag)
    }

    @IBAction func toLikes(_ sender: Any) {
    }
    
    @IBAction func actionsPressed(_ sender: Any) {
    }
    
    @IBAction func toProfile(_ sender: Any) {
        replyView.onAction?(.profile, tag)
    }

}
