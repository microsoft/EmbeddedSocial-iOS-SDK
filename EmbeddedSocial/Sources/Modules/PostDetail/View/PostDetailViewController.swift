//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SVProgressHUD
import SKPhotoBrowser

fileprivate enum CollectionViewSections: Int {
    case post = 0
    case comments
    case sectionsCount
}

class PostDetailViewController: BaseViewController, PostDetailViewInput {

    @IBOutlet weak var collectionView: UICollectionView!
    var output: PostDetailViewOutput!
    
    fileprivate lazy var sizingCell: PostCell = { [unowned self] in
        let cell = PostCell.nib.instantiate(withOwner: nil, options: nil).last as! PostCell
        let width = self.collectionView.bounds.width
        let height = cell.frame.height
        cell.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return cell
        }()
    
    fileprivate var prototypeCommentCell: CommentCell?
    
    //constants
    fileprivate let reloadDelay = 0.2
    fileprivate let commentViewHeight: CGFloat = 35
    
    fileprivate var isNewDataLoading = false

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaButton: UIButton!
    
    fileprivate var photo: Photo?
    fileprivate var postView: UIView!
    fileprivate let imagePikcer = ImagePicker()
    
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
        collectionView.addSubview(self.refreshControl)
        collectionView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.refreshPost()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.refresh()
    }

    // MARK: PostDetailViewInput
    func setupInitialState() {
        imagePikcer.delegate = self
        mediaButton.isEnabled = false
        configCollectionView()
        configTextView()
    }
    
    func refreshPostCell() {
        collectionView.reloadItems(at: [IndexPath(item: 0, section: CollectionViewSections.post.rawValue)])
    }

    private func configCollectionView() {
        prototypeCommentCell = CommentCell.nib.instantiate(withOwner: nil, options: nil).first as? CommentCell
        self.collectionView.register(PostCell.nib, forCellWithReuseIdentifier: PostCell.reuseID)
        self.collectionView.register(CommentCell.nib, forCellWithReuseIdentifier: CommentCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadTable(scrollType: CommentsScrollType) {
        collectionView.reloadData()
        refreshControl.endRefreshing()
        self.isNewDataLoading = false
        commentTextView.isEditable = true
        mediaButton.isEnabled = true
        switch scrollType {
            case .bottom:
                DispatchQueue.main.asyncAfter(deadline: .now() + reloadDelay) {
                    self.scrollCollectionViewToBottom()
                }
            default: break
        }
    }
    
    fileprivate func scrollCollectionViewToBottom() {
        if  output.numberOfItems() > 1 {
            collectionView.scrollToItem(at: IndexPath(row: output.numberOfItems() - 1, section: CollectionViewSections.comments.rawValue), at: .bottom, animated: true)
        }
    }
    
    func refreshCell(index: Int) {
        collectionView.reloadItems(at: [IndexPath.init(row: index, section: CollectionViewSections.comments.rawValue)])
    }
    
    func postCommentSuccess() {
        clearImage()
        commentTextViewHeightConstraint.constant = commentViewHeight
        commentTextView.text = nil
        postButton.isHidden = true
        SVProgressHUD.dismiss()
        view.layoutIfNeeded()
        collectionView.reloadData()
        scrollCollectionViewToBottom()

    }
    
    func postCommentFailed(error: Error) {
        postButton.isHidden = false
        SVProgressHUD.dismiss()
    }
    
    fileprivate func clearImage() {
        photo = nil
        imagePikcer.imageWasSelected = false
        mediaButton.setImage( UIImage(asset: .placeholderPostNoimage), for: .normal)
    }
    
    private func configTextView() {
        commentTextView.isEditable = false
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
        commentTextView.resignFirstResponder()
        SVProgressHUD.show()
        postButton.isHidden = true
        output.postComment(photo: photo, comment: commentTextView.text)
    }
}


extension PostDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case CollectionViewSections.post.rawValue:
            return 1
        case CollectionViewSections.comments.rawValue:
            return output.numberOfItems()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case CollectionViewSections.post.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
            cell.configure(with: output.postViewModel!, collectionView: collectionView)
            cell.usedInThirdPartModule = true
            cell.tag = (output.postViewModel?.tag)!
            return cell
        case CollectionViewSections.comments.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseID, for: indexPath) as! CommentCell
            cell.config(commentView: output.commentViewModel(index: indexPath.row), blockAction: false)
            cell.tag = indexPath.row
            if  output.numberOfItems() - 1 < indexPath.row + 1 && output.enableFetchMore() {
                isNewDataLoading = true
                output.fetchMore()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CollectionViewSections.sectionsCount.rawValue
    }
}

extension PostDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == CollectionViewSections.comments.rawValue {
            output.openReplies(index: indexPath.row)
        }
    }
}

extension PostDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case CollectionViewSections.post.rawValue:
            sizingCell.configure(with: output.postViewModel!, collectionView: collectionView)
            
            // TODO: remake via manual calculation
            sizingCell.needsUpdateConstraints()
            sizingCell.updateConstraints()
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()
            
            return sizingCell.container.bounds.size
        case CollectionViewSections.comments.rawValue:
            prototypeCommentCell?.config(commentView: output.commentViewModel(index: indexPath.row), blockAction: false)
            return CGSize(width: UIScreen.main.bounds.size.width, height: (prototypeCommentCell?.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)!)
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
        output.loadRestComments()
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
