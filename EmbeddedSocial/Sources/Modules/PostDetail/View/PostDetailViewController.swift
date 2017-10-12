//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SKPhotoBrowser

fileprivate enum CommentsSections: Int {
    case post = 0
    case loadMore
    case comments
    case sectionsCount
}

class PostDetailViewController: BaseViewController, PostDetailViewInput {
    
    func showLoadingHUD() {
        showHUD()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var output: PostDetailViewOutput!
    
    fileprivate var prototypeCommentCell: CommentCell?
    
    fileprivate var lastDetailedCommentPath: IndexPath?
    
    //constants
    fileprivate let reloadDelay = 0.2
    fileprivate let commentViewHeight: CGFloat = 35
    
    fileprivate var isNewDataLoading = false

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaButton: UIButton!
    
    @IBOutlet weak var commentInputContainer: UIView!
    
    fileprivate var photo: Photo?
    fileprivate let imagePikcer = ImagePicker()
    
    fileprivate var feedView: UIView?
    
    fileprivate var prototypeCell: CommentCell?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(PostDetailViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(self.refreshControl)
        collectionView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
        apply(theme: theme)
        output.viewIsReady()
        showHUD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let path = lastDetailedCommentPath {
            collectionView.reloadItems(at: [path])
            lastDetailedCommentPath = nil
        }
        
        postButton.isHidden = commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        view.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHUD()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.refresh()
    }
    
    // MARK: PostDetailViewInput
    func setupInitialState() {
        imagePikcer.delegate = self
        configCollectionView()
        configTextView()
    }
    
    func refreshPostCell() {
        collectionView.reloadData()
        if output.heightForFeed() > 0 {
            hideHUD()
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        commentTextView.isEditable = true
        view.isUserInteractionEnabled = true
    }
    
    func updateLoadingCell() {
        collectionView.reloadItems(at: [IndexPath(item: 0, section: CommentsSections.loadMore.rawValue)])
    }

    
    func removeComment(index: Int) {
        collectionView.deleteItems(at: [IndexPath(item: index, section: CommentsSections.comments.rawValue)])
    }

    func updateComments() {
        let numberOfItems = self.output.numberOfItems()
        let itemsInSection = self.collectionView.numberOfItems(inSection: CommentsSections.comments.rawValue)
        let newItemsCount = numberOfItems - itemsInSection
        collectionView.performBatchUpdates({
            var pathes = [IndexPath]()
            if itemsInSection < numberOfItems {
                for index in 0...newItemsCount - 1 {
                    pathes.append(IndexPath(item: index, section: RepliesSections.replies.rawValue))
                }
                self.collectionView.insertItems(at: pathes)
            }
        }) { (updated) in
            if newItemsCount > 0 {
                self.updateLoadingCell()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    private func configCollectionView() {
        prototypeCommentCell = CommentCell.nib.instantiate(withOwner: nil, options: nil).first as? CommentCell
        collectionView.register(PostCell.nib, forCellWithReuseIdentifier: PostCell.reuseID)
        collectionView.register(CommentCell.nib, forCellWithReuseIdentifier: CommentCell.reuseID)
        collectionView.register(LoadMoreCell.nib, forCellWithReuseIdentifier: LoadMoreCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadTable(scrollType: CommentsScrollType) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.isNewDataLoading = false
            self.view.isUserInteractionEnabled = true
            switch scrollType {
            case .bottom:
                DispatchQueue.main.asyncAfter(deadline: .now() + self.reloadDelay) {
                    self.scrollCollectionViewToBottom()
                }
            default: break
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func setFeedViewController(_ feedViewController: UIViewController) {
        feedView = feedViewController.view
    }
    
    func scrollCollectionViewToBottom() {
        if  output.numberOfItems() > 1 {
            collectionView.scrollToItem(at: IndexPath(row: output.numberOfItems() - 1, section: CommentsSections.comments.rawValue), at: .bottom, animated: true)
        }
    }
    
    func refreshCell(index: Int) {
        collectionView.reloadItems(at: [IndexPath.init(row: index, section: CommentsSections.comments.rawValue)])
    }
    
    func postCommentSuccess() {
        clearImage()
        commentTextViewHeightConstraint.constant = commentViewHeight
        commentTextView.text = nil
        postButton.isHidden = true
        hideHUD()
        collectionView.insertItems(at: [IndexPath(item: output.numberOfItems() - 1 , section: CommentsSections.comments.rawValue)])
        view.layoutIfNeeded()
        scrollCollectionViewToBottom()
        view.isUserInteractionEnabled = true
    }
    
    func postCommentFailed(error: Error) {
        postButton.isHidden = false
        view.isUserInteractionEnabled = true
        hideHUD()
    }
    
    fileprivate func clearImage() {
        photo = nil
        imagePikcer.imageWasSelected = false
        mediaButton.setImage( UIImage(asset: .placeholderPostNoimage), for: .normal)
    }
    
    private func configTextView() {
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.cornerRadius = 1
    }
    
    @IBAction func mediaButtonPressed(_ sender: Any) {
        let options = ImagePicker.Options(title: L10n.ImagePicker.choosePlease,
                                          message: nil,
                                          sourceViewController: self)
        imagePikcer.show(with: options)
    }
    
    @IBAction func postComment(_ sender: Any) {
        view.isUserInteractionEnabled = false
        commentTextView.resignFirstResponder()
        showHUD()
        postButton.isHidden = true
        output.postComment(photo: photo, comment: commentTextView.text)
    }
}

extension PostDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case CommentsSections.comments.rawValue:
            let cell = collectionView.cellForItem(at: indexPath) as? CommentCell
            cell?.openReplies()
            lastDetailedCommentPath = indexPath
        default: break
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CommentCell else {
            return
        }
        
        cell.separator.isHidden = indexPath.row == output.numberOfItems() - 1 && indexPath.section == CommentsSections.comments.rawValue
    }
}

extension PostDetailViewController: LoadMoreCellDelegate {
    func loadPressed() {
        if output.canFetchMore() {
            output.fetchMore()
        }
    }
}

extension PostDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case CommentsSections.post.rawValue, CommentsSections.loadMore.rawValue:
            return 1
        case CommentsSections.comments.rawValue:
            return output.numberOfItems()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case CommentsSections.post.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPostCell", for: indexPath)
            cell.backgroundColor = theme?.palette.contentBackground
            
            guard let feedView = feedView else {
                return cell
            }

            if !cell.subviews.contains(feedView) {
                cell.addSubview(feedView)
                feedView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
            }
            return cell
        case CommentsSections.loadMore.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.reuseID, for: indexPath) as! LoadMoreCell
            cell.configure(viewModel: output.loadCellModel())
            cell.apply(theme: theme)
            cell.delegate = self
            return cell
        case CommentsSections.comments.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseID, for: indexPath) as! CommentCell
            let config = CommentCellModuleConfigurator()
            config.configure(cell: cell,
                             comment: output.comment(at: indexPath.row),
                             navigationController: self.navigationController,
                             moduleOutput: self.output as! CommentCellModuleOutout)
            cell.repliesButton.isHidden = false
            cell.tag = indexPath.row
            cell.apply(theme: theme)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CommentsSections.sectionsCount.rawValue
    }
}

extension PostDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        switch indexPath.section {
        case CommentsSections.post.rawValue:
            // TODO: Feed module should be fix itself size in offline mode
            return CGSize(width: screenWidth, height: output.heightForFeed() < 1 ? 1 : output.heightForFeed() )
        case CommentsSections.loadMore.rawValue:
            return CGSize(width: screenWidth, height: output.loadCellModel().cellHeight)
        case CommentsSections.comments.rawValue:
            prototypeCommentCell?.configure(comment: output.comment(at: indexPath.row))
            return CGSize(width: screenWidth, height: (prototypeCommentCell?.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)!)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

extension PostDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        commentTextViewHeightConstraint.constant = commentTextView.contentSize.height
        view.layoutIfNeeded()
        postButton.isHidden = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollCollectionViewToBottom()
    }
    
}

// MARK: ImagePickerDelegate
extension PostDetailViewController: ImagePickerDelegate {
    func selected(photo: Photo) {
        self.photo = photo
        mediaButton.setImage(photo.image, for: .normal)
    }
    
    func removePhoto() {
        clearImage()
    }
}

extension PostDetailViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        
        view.backgroundColor = palette.contentBackground
        collectionView.backgroundColor = palette.contentBackground
        
        let attrs: [String : Any] = [NSForegroundColorAttributeName: palette.textPlaceholder, NSFontAttributeName: AppFonts.medium]
        commentTextView.textColor = palette.textPrimary
        commentTextView.attributedPlaceholder = NSAttributedString(string: L10n.PostDetails.commentPlaceholder, attributes: attrs)
        commentTextView.font = AppFonts.medium
        commentTextView.backgroundColor = palette.contentBackground
        
        commentInputContainer.backgroundColor = palette.contentBackground
        
        refreshControl.tintColor = palette.loadingIndicator
    }
}
