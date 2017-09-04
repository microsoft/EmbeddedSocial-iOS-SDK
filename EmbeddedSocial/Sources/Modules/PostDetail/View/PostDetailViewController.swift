//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SVProgressHUD
import SKPhotoBrowser

fileprivate enum CommentsSections: Int {
    case post = 0
    case comments
    case sectionsCount
}

class PostDetailViewController: BaseViewController, PostDetailViewInput {

    @IBOutlet weak var collectionView: UICollectionView!
    var output: PostDetailViewOutput!
    
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
        collectionView.addSubview(self.refreshControl)
        collectionView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
        output.viewIsReady()
        SVProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if output.numberOfItems() > 0 {
            collectionView.performBatchUpdates({
                var pathes = [IndexPath]()
                self.collectionView.numberOfItems(inSection: CommentsSections.comments.rawValue)
                for index in 0...self.output.numberOfItems() - 1 {
                    pathes.append(IndexPath(item: index, section: CommentsSections.comments.rawValue))
                }
                self.collectionView.reloadItems(at: pathes)
            }, completion: nil)
        }

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
        collectionView.reloadData()
        SVProgressHUD.dismiss()
    }

    func updateComments() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    private func configCollectionView() {
        prototypeCommentCell = CommentCell.nib.instantiate(withOwner: nil, options: nil).first as? CommentCell
        self.collectionView.register(PostCell.nib, forCellWithReuseIdentifier: PostCell.reuseID)
        self.collectionView.register(CommentCell.nib, forCellWithReuseIdentifier: CommentCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadTable(scrollType: CommentsScrollType) {
        self.collectionView.reloadData()
        self.isNewDataLoading = false
        self.commentTextView.isEditable = true
        self.mediaButton.isEnabled = true
        switch scrollType {
        case .bottom:
            DispatchQueue.main.asyncAfter(deadline: .now() + self.reloadDelay) {
                self.scrollCollectionViewToBottom()
            }
        default: break
        }
        
        refreshControl.endRefreshing()

    }
    
    func setFeedViewController(_ feedViewController: UIViewController) {
        feedView = feedViewController.view
    }
    
    fileprivate func scrollCollectionViewToBottom() {
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

extension PostDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == CommentsSections.comments.rawValue {
            let cell = collectionView.cellForItem(at: indexPath) as? CommentCell
            cell?.openReplies()
        }
    }
}

extension PostDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case CommentsSections.post.rawValue:
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
            
            guard let feedView = feedView else {
                return cell
            }

            if !cell.subviews.contains(feedView) {
                cell.addSubview(feedView)
                feedView.snp.makeConstraints { make in
                    make.left.equalTo(cell)
                    make.right.equalTo(cell)
                    make.top.equalTo(cell)
                    make.bottom.equalTo(cell)
                }
                
            }
            return cell
        case CommentsSections.comments.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseID, for: indexPath) as! CommentCell
            let config = CommentCellModuleConfigurator()
            config.configure(cell: cell, comment: output.comment(at: indexPath.row), navigationController: self.navigationController)
            cell.tag = indexPath.row
            if  output.numberOfItems() - 1 == indexPath.row && output.enableFetchMore() {
                output.fetchMore()
                SVProgressHUD.show()
            }
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
        switch indexPath.section {
        case CommentsSections.post.rawValue:
            // TODO: Feed module should be fix itself size in offline mode
            return CGSize(width: UIScreen.main.bounds.size.width, height: output.heightForFeed() < 1 ? 1 : output.heightForFeed() )
        case CommentsSections.comments.rawValue:
            prototypeCommentCell?.configure(comment: output.comment(at: indexPath.row))
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

