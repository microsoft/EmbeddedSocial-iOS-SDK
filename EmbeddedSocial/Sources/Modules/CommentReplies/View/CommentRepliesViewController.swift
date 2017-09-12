//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SVProgressHUD

enum RepliesSections: Int {
    case comment = 0
    case loadMore
    case replies
    case sectionsCount
}

fileprivate let indicatorViewHeight: CGFloat = 44

class CommentRepliesViewController: BaseViewController, CommentRepliesViewInput {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var replyTextViewHeightConstraint: NSLayoutConstraint!
    
    var output: CommentRepliesViewOutput!

    fileprivate var isNewDataLoading = false
    fileprivate let reloadDelay = 0.2
    
    fileprivate var prototypeCommentCell: CommentCell!
    fileprivate var prototypeReplyCell: ReplyCell!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(CommentRepliesViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.addSubview(self.refreshControl)
        collectionView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
        view.isUserInteractionEnabled = false
        configCollecionView()
        configTextView()
        output.viewIsReady()
    }
    
    fileprivate var collectionViewIsUpdateing = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Internal
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.refresh()
    }

    func configCollecionView() {
        prototypeReplyCell = ReplyCell.nib.instantiate(withOwner: nil, options: nil).first as? ReplyCell
        prototypeCommentCell = CommentCell.nib.instantiate(withOwner: nil, options: nil).first as? CommentCell
        collectionView.register(ReplyCell.nib, forCellWithReuseIdentifier: ReplyCell.reuseID)
        collectionView.register(LoadMoreCell.nib, forCellWithReuseIdentifier: LoadMoreCell.reuseID)
        collectionView.register(CommentCell.nib, forCellWithReuseIdentifier: CommentCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configTextView() {
        replyTextView.delegate = self
        replyTextView.layer.borderWidth = 1
        replyTextView.layer.borderColor = UIColor.lightGray.cgColor
        replyTextView.layer.cornerRadius = 1
    }
    
    fileprivate func scrollTableToBottom() {
        if  output.numberOfItems() > 1 {
            collectionView.scrollToItem(at: IndexPath(row: output.numberOfItems() - 1, section: RepliesSections.replies.rawValue), at: .bottom, animated: true)
        }
    }
    
    func lockUI() {
        view.isUserInteractionEnabled = false
        SVProgressHUD.show()
    }
    
    fileprivate func unlockUI() {
        view.isUserInteractionEnabled = true
        SVProgressHUD.dismiss()
    }
 
    @IBAction func postReply(_ sender: Any) {
        output.postReply(text: replyTextView.text)
    }
    
    // MARK: CommentRepliesViewInput
    func reloadReplies() {
        collectionView.performBatchUpdates({ 
            let numberOfItems = self.output.numberOfItems()
            let itemsInSection = self.collectionView.numberOfItems(inSection: RepliesSections.replies.rawValue)
            let newItemsCount = numberOfItems - itemsInSection
            var pathes = [IndexPath]()
            if itemsInSection < numberOfItems {
                for index in 0...newItemsCount - 1 {
                    pathes.append(IndexPath(item: index, section: RepliesSections.replies.rawValue))
                }
                self.collectionView.insertItems(at: pathes)
            }
        }) { (updated) in
            self.updateLoadingCell()
            self.refreshControl.endRefreshing()
            self.unlockUI()
        }
    }
    
    func updateLoadingCell() {
        collectionView.reloadItems(at: [IndexPath(item: 0, section: RepliesSections.loadMore.rawValue)])
    }

    func refreshReplyCell(index: Int) {
        collectionView.reloadItems(at: [IndexPath(item: index, section: RepliesSections.replies.rawValue)])
    }
    
    func removeReply(index: Int) {
        collectionView.deleteItems(at: [IndexPath(item: index, section: RepliesSections.replies.rawValue)])
    }
    
    func reloadTable(scrollType: RepliesScrollType) {
        postButton.isHidden = replyTextView.text.isEmpty
        collectionView.reloadSections([RepliesSections.replies.rawValue])
        refreshControl.endRefreshing()
        unlockUI()
        switch scrollType {
        case .bottom:
            DispatchQueue.main.asyncAfter(deadline: .now() + reloadDelay) {
                self.scrollTableToBottom()
            }
        default: break
        }
    }

    func setupInitialState() {
    }
    
    func replyPosted() {
        collectionView.insertItems(at: [IndexPath(item: output.numberOfItems() - 1, section: RepliesSections.replies.rawValue)])
        scrollTableToBottom()
        replyTextView.text = ""
        postButton.isHidden = true
        unlockUI()
    }
    
    func refreshCommentCell() {
        collectionView.reloadItems(at: [IndexPath(item: 0, section: RepliesSections.comment.rawValue)])
    }
    
}

extension CommentRepliesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return RepliesSections.sectionsCount.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case RepliesSections.comment.rawValue, RepliesSections.loadMore.rawValue:
            return 1
        case RepliesSections.replies.rawValue:
            return output.numberOfItems()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case RepliesSections.comment.rawValue:
                let cell = output.mainCommentCell()
                cell.repliesButton.isHidden = true
                return cell
        case RepliesSections.loadMore.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.reuseID, for: indexPath) as! LoadMoreCell
            cell.configure(viewModel: output.loadCellModel())
            cell.delegate = self
            return cell
            case RepliesSections.replies.rawValue:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReplyCell.reuseID, for: indexPath) as! ReplyCell
                cell.config(replyView: output.replyView(index: indexPath.row))
                cell.tag = indexPath.row
                return cell
            default:
                return UICollectionViewCell()
            }
    }
}

extension CommentRepliesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == RepliesSections.replies.rawValue {
            replyTextView.resignFirstResponder()
        }
    }
}

extension CommentRepliesViewController: LoadMoreCellDelegate {
    func loadPressed() {
        if output.canFetchMore() {
            output.fetchMore()
        }
    }
}

extension CommentRepliesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case RepliesSections.comment.rawValue:
            return output.mainCommentCell().frame.size
        case RepliesSections.loadMore.rawValue:
            return CGSize(width: UIScreen.main.bounds.width, height: output.loadCellModel().cellHeight)
        case RepliesSections.replies.rawValue:
            prototypeReplyCell.config(replyView: output.replyView(index: indexPath.row))
            print(prototypeReplyCell.cellSize())
            return prototypeReplyCell.cellSize()
        default:
            return CGSize()
        }
    }
}

extension CommentRepliesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        replyTextViewHeightConstraint.constant = replyTextView.contentSize.height
        view.layoutIfNeeded()
        postButton.isHidden = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        output.loadRestReplies()
    }
    
}
