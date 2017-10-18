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
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repliesButton: UIButton!

    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    var commentView: CommentViewModel!
    
    var output: CommentCellViewOutput!
    
    private var formatter = DateFormatterTool()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPhoto.contentMode = .scaleAspectFill
        mediaImageView.layer.drawsAsynchronously = true
        mediaImageView.layer.shouldRasterize = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(mediaPressed))
        mediaImageView.addGestureRecognizer(tap)
        apply(theme: theme)
    }
    
    static let identifier = "CommentCell"
    static let defaultHeight: CGFloat = 190
    
    func setupInitialState() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.layer.bounds.height / 2
    }
    
    override func prepareForReuse() {
        mediaImageView.releasePhoto()
        userPhoto.releasePhoto()
    }
    
    func configure(comment: Comment) {
        userName.text = User.fullName(firstName: comment.user?.firstName, lastName: comment.user?.lastName)
        commentTextLabel.text = comment.text ?? ""
        likesCountButton.setTitle(L10n.Post.likesCount(Int(comment.totalLikes)), for: .normal)
        repliesCountButton.setTitle(L10n.Post.repliesCount(Int(comment.totalReplies)), for: .normal)
        
        postedTimeLabel.text = comment.createdTime == nil ? "" : formatter.shortStyle.string(from: comment.createdTime!, to: Date())!
        
        if comment.user?.photo?.url == nil {
            userPhoto.image = userImagePlaceholder
        } else {
            userPhoto.setPhotoWithCaching(Photo(url: comment.user?.photo?.url),
                                          placeholder: userImagePlaceholder)
        }
        
        likeButton.isSelected = comment.liked
        
        if let photo = comment.mediaPhoto {
            mediaImageView.contentMode = .scaleAspectFill
            if let url = photo.url {
                let resziedPhoto = Photo(uid: photo.uid, url: url + Constants.ImageResize.pixels250, image: photo.image)
                mediaImageView.setPhotoWithCaching(resziedPhoto, placeholder: postImagePlaceholder)
            } else {
                mediaImageView.setPhotoWithCaching(photo, placeholder: postImagePlaceholder)
            }

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
    
    private lazy var postImagePlaceholder: UIImage = {
        return UIImage(asset: Asset.placeholderPostNoimage)
    }()
    
    private lazy var userImagePlaceholder: UIImage = {
        return UIImage(asset: AppConfiguration.shared.theme.assets.userPhotoPlaceholder)
    }()
}
