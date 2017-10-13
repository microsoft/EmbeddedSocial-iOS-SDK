//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import TTTAttributedLabel

class PostCell: UICollectionViewCell, PostCellProtocol {
 
    weak var collectionView: UICollectionView!
    var viewModel: PostViewModel!
    
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
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
    @IBOutlet weak var postImageButton: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postText: TTTAttributedLabel!
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var likedList: UILabel!
    
    var usedInThirdPartModule = false
    
    func indexPath() -> IndexPath? {
        return collectionView.indexPath(for: self)
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
        postImageButton.imageView?.contentMode = .scaleAspectFill
        postText.numberOfLines = Constants.FeedModule.Collection.Cell.maxLines
        postImageHeight.constant = Constants.FeedModule.Collection.imageHeight
    }
    
    func setup() {
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        viewModel = nil
        userName.text = nil
        postTitle.text = nil
        postText.setText("")
        postCreation.text = nil
        likedCount.text = nil
        commentedCount.text = nil
        collectionView = nil
        
        postImageButton.releasePhoto()
        userPhoto.releasePhoto()
        postImageHeight.constant = Constants.FeedModule.Collection.imageHeight
        
        super.prepareForReuse()
    }
    
    func configure(with data: PostViewModel, collectionView: UICollectionView?) {
        
        viewModel = data
        self.collectionView = collectionView
        
        // showing post image if url is available, else - hiding
        if data.postImageUrl == nil {
            postImageHeight.constant = 0
        }
        
//        print(ImageCacheAdapter.shared.store(photo: Photo(uid: data.postImageHandle ?? "")))
        let downloadablePostImage = Photo(uid: data.postImageHandle ?? "", url: data.postImageUrl)
        postImageButton.setPhotoWithCaching(downloadablePostImage, placeholder: postImagePlaceholder)
        
        let downloadableUserImage = Photo(url: data.userImageUrl)
        userPhoto.setPhotoWithCaching(downloadableUserImage, placeholder: userImagePlaceholder)
        
        userName.text = data.userName
        postTitle.text = data.title
        postText.setText(data.text)
        postCreation.text = data.timeCreated
        likedCount.text = data.totalLikes
        commentedCount.text = data.totalComments
        
        // Buttons
        likeButton.isSelected = data.isLiked
        pinButton.isSelected = data.isPinned
        commentButton.isEnabled = !usedInThirdPartModule
        
        // Text View
//        postText.readMoreTapHandle = { [weak self] in
//            self?.handleAction(action: .postDetailed)
//        }
        
        //        postText.isTrimmed = data.isTrimmed
        
        if data.isTrimmed {
            postText.attributedTruncationToken = NSMutableAttributedString(
                string: "... Show more",
                attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
        
        let text = postText.text!
        let regex = try NSRegularExpression(pattern: "(?:\\s|^)(#(?:[a-zA-Z].*?|\\d+[a-zA-Z]+.*?))\\b", options: NSRegularExpression.MatchingOptions.anchored)
        let results = regex.matchesInString(text,
                                            options: NSRegularExpression.MatchingOptions.anchored
                                            range: NSMakeRange(0, text.characters.count))
        
        //postText.enabledTextCheckingTypes = NSTextCheckingTypeLink
        let r = NSRange()
        postText.addLink(toTransitInformation: ["hashtag": 1], with: NSRange( ))
    }
    
    static func sizingCell() -> PostCell {
        let cell = PostCell.nib.instantiate(withOwner: nil, options: nil).last as! PostCell
        return cell
    }
    
    // calculates static and dynamic(TextView) items
    func getHeight(with width: CGFloat) -> CGFloat {
        
        // sum all static blocks
        var staticElementsHeight = staticHeigthElements.reduce(0) { result, view in
            return result + view.frame.size.height
        }
        
        let staticConstraintsHeight = staticConstaints.reduce(0) { result, constraint in
            return result + constraint.constant
        }
        
        // ignore image height if none
        if viewModel.postImageUrl == nil {
            staticElementsHeight -= Constants.FeedModule.Collection.imageHeight
        }
        
        // dynamic part of calculation:
        let bounds = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        
        let dynamicHeight = TTTAttributedLabel.sizeThatFitsAttributedString(
            postText.attributedText,
            withConstraints: bounds,
            limitedToNumberOfLines: UInt(Constants.FeedModule.Collection.Cell.maxLines)).height
        

        let result = [staticElementsHeight, dynamicHeight, staticConstraintsHeight].reduce(0.0, +)
        
        Logger.log(postText.text, event: .veryImportant)
        return result
    }
    
    // MARK: Private
    
    private func handleAction(action: FeedPostCellAction) {
        guard let path = indexPath() else { return }
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
