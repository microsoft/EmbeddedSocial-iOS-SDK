//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import UIKit

enum CommentCellAction {
    case like, replies, profile, photo
}

class CommentCell: UICollectionViewCell {

    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var repliesCountButton: UIButton!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var mediaButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repliesButton: UIButton!

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    var commentView: CommentViewModel!
    
    private var formatter = DateFormatterTool()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.layer.shouldRasterize = true
        avatarButton.layer.drawsAsynchronously = true
    }
    
    static let identifier = "CommentCell"
    static let defaultHeight: CGFloat = 190

    func config(commentView: CommentViewModel, blockAction: Bool) {
        self.commentView = commentView
        avatarButton.setPhotoWithCaching(Photo(uid: UUID().uuidString,
                                               url: commentView.userImageUrl,
                                               image: nil),
                                         placeholder: UIImage(asset: .userPhotoPlaceholder))
        repliesCountButton.setTitle(commentView.totalReplies, for: .normal)
        likesCountButton.setTitle(commentView.totalLikes, for: .normal)
        commentTextLabel.text = commentView.text
        usernameLabel.text = commentView.userName
        if let url = commentView.commentImageUrl {
            mediaButton.imageView?.contentMode = .scaleAspectFill
            mediaButton.setPhotoWithCaching(Photo(uid: UUID().uuidString,
                                                  url: url,
                                                  image: nil),
                                            placeholder: UIImage(asset: .placeholderPostNoimage))
            mediaButtonHeightConstraint.constant = UIScreen.main.bounds.size.height/3
            
        } else {
            mediaButtonHeightConstraint.constant = 0
        }
        
        postedTimeLabel.text = commentView.timeCreated
        likeButton.isSelected = commentView.isLiked

        repliesButton.isEnabled = !blockAction

        
        contentView.layoutIfNeeded()
    }

    func cellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: self.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
    }
    
    @IBAction func commentOptionsPressed(_ sender: Any) {
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        commentView.onAction?(.like, tag)
    }

    @IBAction func commentPressed(_ sender: Any) {
        commentView.onAction?(.replies, tag)
    }
    @IBAction func avatarPressed(_ sender: Any) {
        commentView.onAction?(.profile, tag)
    }
    
    @IBAction func mediaPressed(_ sender: Any) {
        commentView.onAction?(.photo, tag)
    }
}
