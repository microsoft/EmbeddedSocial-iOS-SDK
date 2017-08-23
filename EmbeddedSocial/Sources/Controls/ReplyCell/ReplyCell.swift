//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ReplyCell: UICollectionViewCell {

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
        contentView.layoutIfNeeded()
    }
    
    func cellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: self.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
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
