//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SVProgressHUD

enum RepliesSections: Int {
    case comment = 0
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
    
    fileprivate lazy var loadingIndicatorView: LoadingIndicatorView = { [unowned self] in
        let frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: indicatorViewHeight)
        let view = LoadingIndicatorView(frame: frame)
        view.apply(style: .standard)
        return view
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
    
    // MARK: Internal
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.refresh()
    }

    func configCollecionView() {
        prototypeReplyCell = ReplyCell.nib.instantiate(withOwner: nil, options: nil).first as? ReplyCell
        prototypeCommentCell = CommentCell.nib.instantiate(withOwner: nil, options: nil).first as? CommentCell
        collectionView.register(ReplyCell.nib, forCellWithReuseIdentifier: ReplyCell.reuseID)
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
    
    private func lockUI() {
        view.isUserInteractionEnabled = false
        SVProgressHUD.show()
    }
    
    private func unlockUI() {
        view.isUserInteractionEnabled = true
        SVProgressHUD.dismiss()
    }
 
    @IBAction func postReply(_ sender: Any) {
        lockUI()
        output.postReply(text: replyTextView.text)
    }
    
    // MARK: CommentRepliesViewInput
    func reloadReplies() {
        collectionView.reloadSections(IndexSet(integer: RepliesSections.replies.rawValue))
    }

    func refreshReplyCell(index: Int) {
        collectionView.reloadItems(at: [IndexPath(item: index, section: RepliesSections.replies.rawValue)])
    }
    
    func reloadTable(scrollType: RepliesScrollType) {
        refreshControl.endRefreshing()
        self.isNewDataLoading = false
        unlockUI()
        postButton.isHidden = replyTextView.text.isEmpty
        collectionView.reloadData()
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
        reloadReplies()
        replyTextView.text = ""
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
        case RepliesSections.comment.rawValue:
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseID, for: indexPath) as! CommentCell
                cell.config(commentView: output.mainComment(), blockAction: true)
                cell.tag = output.mainComment().tag
                return cell
            case RepliesSections.replies.rawValue:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReplyCell.reuseID, for: indexPath) as! ReplyCell
                cell.config(replyView: output.replyView(index: indexPath.row))
                cell.tag = indexPath.row
                if  output.numberOfItems() - 1 < indexPath.row + 1 && isNewDataLoading == false && output.canFetchMore() {
                    isNewDataLoading = true
                    output.fetchMore()
                }
                return cell
            default:
                return UICollectionViewCell()
            }
    }
}

extension CommentRepliesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case RepliesSections.comment.rawValue:
            prototypeCommentCell.config(commentView: output.mainComment(), blockAction: true)
            return prototypeCommentCell.cellSize()
        case RepliesSections.replies.rawValue:
            prototypeReplyCell.config(replyView: output.replyView(index: indexPath.row))
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
