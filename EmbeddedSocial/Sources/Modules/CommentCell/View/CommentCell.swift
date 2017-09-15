//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import UIKit

enum CommentCellAction {
    case like, replies, profile, photo
}

class CommentCell: UICollectionViewCell, CommentCellViewInput {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var repliesCountButton: UIButton!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var mediaButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repliesButton: UIButton!

    @IBOutlet weak var postedTimeLabel: UILabel!
    
    var commentView: CommentViewModel!
    
    var output: CommentCellViewOutput!
    
    private var formatter = DateFormatterTool()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPhoto.contentMode = .scaleAspectFill
        layer.shouldRasterize = true
        layer.drawsAsynchronously = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    static let identifier = "CommentCell"
    static let defaultHeight: CGFloat = 190
    
    func setupInitialState() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.layer.bounds.height / 2
    }
    
    func configure(comment: Comment) {
        userName.text = User.fullName(firstName: comment.firstName, lastName: comment.lastName)
        commentTextLabel.text = comment.text ?? ""
        likesCountButton.setTitle(L10n.Post.likesCount(Int(comment.totalLikes)), for: .normal)
        repliesCountButton.setTitle(L10n.Post.repliesCount(Int(comment.totalReplies)), for: .normal)
        
        postedTimeLabel.text = comment.createdTime == nil ? "" : formatter.shortStyle.string(from: comment.createdTime!, to: Date())!
        
        
        if comment.photoUrl == nil {
            userPhoto.image = UIImage(asset: Asset.userPhotoPlaceholder)
        } else {
            userPhoto.setPhotoWithCaching(Photo(url: comment.photoUrl), placeholder: UIImage(asset: Asset.userPhotoPlaceholder))
        }
        
        likeButton.isSelected = comment.liked
        
        if let url = comment.mediaUrl {
            mediaButton.imageView?.contentMode = .scaleAspectFill
            mediaButton.setPhotoWithCaching(Photo(uid: UUID().uuidString,
                                                  url: url,
                                                  image: nil),
                                            placeholder: UIImage(asset: .placeholderPostNoimage))
            mediaButtonHeightConstraint.constant = UIScreen.main.bounds.size.height/3
            
        } else {
            mediaButtonHeightConstraint.constant = 0
        }
    }

    func cellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: self.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
    }
    

    @IBAction func likesButtonPressed(_ sender: Any) {
        output.likesPressed()
    }
    
    @IBAction private func commentOptionsPressed(_ sender: Any) {
        output.optionsPressed()
    }
    
    @IBAction private func likePressed(_ sender: UIButton) {
        output.like()
    }

    @IBAction private func commentPressed(_ sender: Any) {
        output.toReplies(scrollType: .bottom)
    }
    @IBAction private func avatarPressed(_ sender: Any) {
        output.avatarPressed()
    }
    
    @IBAction private func mediaPressed(_ sender: Any) {
        output.mediaPressed()
    }
    
    func openReplies() {
        output.toReplies(scrollType: .none)
    }
}
