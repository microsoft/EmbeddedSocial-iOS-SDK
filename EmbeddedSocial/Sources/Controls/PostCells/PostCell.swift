//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import TTTAttributedLabel

class PostCell: UICollectionViewCell, PostCellProtocol {
 
    weak var collectionView: UICollectionView!
    var viewModel: PostViewModel!
    var cache: ImageCache = ImageCacheAdapter.shared
    
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
    @IBOutlet weak var postTextContainerPaddingLeft: NSLayoutConstraint!
    @IBOutlet weak var postTextContainerPaddingRight: NSLayoutConstraint!
    @IBOutlet var staticHeigthElements: [UIView]!
    @IBOutlet var staticConstaints: [NSLayoutConstraint]!
    
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
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: FeedTextLabel!
    @IBOutlet weak var postText: FeedTextLabel!
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var likedList: UILabel!
    
    var usedInThirdPartModule = false

    func getImageHeight(containerHeight: CGFloat?) -> CGFloat {
        
        guard imageIsAvailable else {
            return 0
        }
        
        guard let height = containerHeight else {
            return Constants.FeedModule.Collection.imageHeight
        }
        
        let ratio = Constants.FeedModule.Collection.imageRatio
        let result = height * ratio
        
        return max(result, Constants.FeedModule.Collection.imageHeight)
    }
    
    func indexPath() -> IndexPath? {
        return collectionView.indexPath(for: self)
    }
    
    private var imageIsAvailable: Bool {
        guard viewModel != nil, let photo = viewModel.postPhoto else {
            return false
        }
        return cache.image(for: photo) != nil || photo.url != nil
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.layer.bounds.height / 2
    }
    
    override func awakeFromNib() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(container)
        postImageHeight.constant = Constants.FeedModule.Collection.imageHeight
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        postImage.clipsToBounds = true
        postImage.contentMode = .scaleAspectFill
    }
    
    func setup() {
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        viewModel = nil
        userName.text = nil
        postTitle.text = nil
        postText.setFeedText("")
        postText.eventHandler = nil
        postCreation.text = nil
        likedCount.text = nil
        commentedCount.text = nil
        collectionView = nil
        
        postImage.releasePhoto()
        userPhoto.releasePhoto()
        
        postImageHeight.constant = getImageHeight(containerHeight: nil)
        
        super.prepareForReuse()
    }
    
    func configure(with data: PostViewModel, collectionView: UICollectionView?) {
        
        viewModel = data
        self.collectionView = collectionView
        let containerHeight = collectionView?.bounds.height
        
        // Narrow views above 340px should use short strings
        let shouldUseShortStrings = collectionView == nil ? false : (UIScreen.main.bounds.width <= 340)
        
        postImageHeight.constant = getImageHeight(containerHeight: containerHeight)
        
        postImage.isHidden = (postImageHeight.constant == 0)
        
        postImage.setPhotoWithCaching(data.postPhoto, placeholder: postImagePlaceholder)
        
        let downloadableUserImage = Photo(url: data.userImageUrl)
        userPhoto.setPhotoWithCaching(downloadableUserImage, placeholder: userImagePlaceholder)
        
        userName.text = data.userName

        configTitleLabel()
        postTitle.setFeedText(data.title, shouldTrim: false)
        postText.setFeedText(data.text, shouldTrim: data.isTrimmed)
        postText.eventHandler = self
        postCreation.text = data.timeCreated
        likedCount.text = shouldUseShortStrings ? data.totalLikesShort : data.totalLikes
        commentedCount.text = shouldUseShortStrings ? data.totalCommentsShort : data.totalComments
        
        // Buttons
        likeButton.isSelected = data.isLiked
        pinButton.isSelected = data.isPinned
        commentButton.isEnabled = !usedInThirdPartModule
   
    }
    
    private func configTitleLabel() {
        postTitle.textAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        postTitle.tagAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: Palette.green,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue
        ]
        postTitle.eventHandler = self
    }
    
    static func sizingCell() -> PostCell {
        let cell = PostCell.nib.instantiate(withOwner: nil, options: nil).last as! PostCell
        return cell
    }
    
    // calculates static and dynamic items
    func getHeight(containerHeight: CGFloat, with width: CGFloat, isTrimmed: Bool = false) -> CGFloat {
        
        // sum all static blocks
        let staticElementsHeight = staticHeigthElements.reduce(0) { result, view in
            return result + view.frame.size.height
        }
        
        let staticConstraintsHeight = staticConstaints.reduce(0) { result, constraint in
            return result + constraint.constant
        }
        
        let imageHeight = getImageHeight(containerHeight: containerHeight)
        
        // calculate text width:
        let padding = postTextContainerPaddingLeft.constant + postTextContainerPaddingRight.constant
        let bounds = CGSize(width: width - padding, height: CGFloat.greatestFiniteMagnitude)
        
        let maxLines = isTrimmed ? Constants.FeedModule.Collection.Cell.trimmedMaxLines : Constants.FeedModule.Collection.Cell.maxLines
    
        let dynamicHeight = TTTAttributedLabel.sizeThatFitsAttributedString(
            postText.attributedText,
            withConstraints: bounds,
            limitedToNumberOfLines: UInt(maxLines)).height
        
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)

        let result = [staticElementsHeight, dynamicHeight, imageHeight, staticConstraintsHeight].reduce(0.0, +)
        
        return result
    }
    
    // MARK: Private
    
    fileprivate func handleAction(action: FeedPostCellAction) {
        
        guard let path = indexPath() else {
            Logger.log("Trying to handle event out of collection view", event: .error)
            return
        }
        
        viewModel.onAction?(action, path)
    }

    private lazy var postImagePlaceholder: UIImage = {
        return UIImage(asset: Asset.placeholderPostNoimage)
    }()
    
    private lazy var userImagePlaceholder: UIImage = {
        return UIImage(asset: AppConfiguration.shared.theme.assets.userPhotoPlaceholder)
    }()
    
    deinit {
        Logger.log()
    }
}

extension PostCell: FeedTextLabelHandler {
    
    func didTapHashtag(string: String) {
        handleAction(action: .hashtag(string))
    }
    
    func didTapReadMore() {
        handleAction(action: .postDetailed)
    }
}
