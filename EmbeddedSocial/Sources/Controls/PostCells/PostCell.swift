//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class PostCell: UICollectionViewCell, PostCellProtocol {
 
    weak var collectionView: UICollectionView!
    var viewModel: PostViewModel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var userPhoto: UIImageView! {
        didSet {
            userPhoto.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postCreation: UILabel!
    @IBOutlet weak var postImageButton: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postText: UITextView! {
        didSet {
            postText.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 5)
            postText.textContainer.lineFragmentPadding = 0
        }
    }
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var likedList: UILabel!
    
    var usedInThirdPartModule = false
    
    func indexPath() -> IndexPath {
        return collectionView.indexPath(for: self)!
    }
    
    @IBAction private func onTapPhoto(_ sender: Any) {
        handleAction(action: .photo)
    }
    
    @IBAction private func onProfileInfo(_ sender: Any) {
        handleAction(action: .profile)
    }
    
    @IBAction private func onTapLike(_ sender: Any) {
        handleAction(action: .like)
    }
    
    @IBAction private func onTapCommented(_ sender: Any) {
        handleAction(action: .comment)
    }
    
    @IBAction private func onTapPin(_ sender: Any) {
         handleAction(action: .pin)
    }
    
    @IBAction private func onTapExtra(_ sender: Any) {
        handleAction(action: .extra)
    }
    
    @IBAction func onLikesList(_ sender: UIButton) {
        handleAction(action: .likesList)
    }
    
    @IBOutlet weak var likedCount: UILabel!
    @IBOutlet weak var commentedCount: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func handleAction(action: FeedPostCellAction) {
        usedInThirdPartModule ? viewModel.onAction?(action, IndexPath(item: tag, section: 0)) : viewModel.onAction?(action, indexPath())
    }
    
    func setup() {
        clipsToBounds = true
    }
    
    func configure(with data: PostViewModel, collectionView: UICollectionView?) {
        
        self.viewModel = data
        self.collectionView = collectionView
        
        if data.postImageUrl == nil {
            postImageButton.setImage(postImagePlaceholder, for: .normal)
        } else {
            postImageButton.setPhotoWithCaching(Photo(url: data.postImageUrl), placeholder: postImagePlaceholder)
        }
        
        if data.userImageUrl == nil {
            userPhoto.image = userImagePlaceholder
        } else {
            userPhoto.setPhotoWithCaching(Photo(url: data.userImageUrl), placeholder: userImagePlaceholder)
        }
        
        userName.text = data.userName
        postTitle.text = data.title
        postText.text = data.text
        postCreation.text = data.timeCreated
        likedCount.text = data.totalLikes
        commentedCount.text = data.totalComments
        
        // Buttons
        likeButton.isSelected = data.isLiked
        pinButton.isSelected = data.isPinned
        commentButton.isEnabled = !usedInThirdPartModule
    }
    
    private lazy var postImagePlaceholder: UIImage = {
        return UIImage(asset: Asset.placeholderPostNoimage)
    }()
    
    private lazy var userImagePlaceholder: UIImage = {
        return UIImage(asset: Asset.userPhotoPlaceholder)
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.layer.bounds.height / 2
    }
    
    override func awakeFromNib() {
        self.contentView.addSubview(container)
        self.postImageButton.imageView?.contentMode = .scaleAspectFill
    }
    
}
