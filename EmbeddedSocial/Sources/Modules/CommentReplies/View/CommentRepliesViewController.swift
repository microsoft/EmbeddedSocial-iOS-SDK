//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

enum RepliesSections: Int {
    case comment = 0
    case loadMore
    case replies
    case sectionsCount
}

fileprivate let indicatorViewHeight: CGFloat = 44

class CommentRepliesViewController: BaseViewController, CommentRepliesViewInput {

    @IBOutlet weak var postButton: UIButton!
    var replyTextView = UITextView()
    var replyTextViewHeightConstraint: Constraint!
    
    var output: CommentRepliesViewOutput!

    fileprivate var isNewDataLoading = false
    fileprivate let reloadDelay = 0.2
    fileprivate let replyViewHeight: CGFloat = 35
    fileprivate let replyViewHeightForIPhone5: CGFloat = 45
    fileprivate let leftTextViewOffset: CGFloat = 20
    fileprivate let rightTextViewOffset: CGFloat = 20
    fileprivate let topTextViewOffset: CGFloat = 10
    
    fileprivate var prototypeCommentCell: CommentCell!
    fileprivate var prototypeReplyCell: ReplyCell!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var replyInputContainer: UIView!
    
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
        replyTextView.delegate = self
        configTextView()
        apply(theme: theme)
        output.viewIsReady()
    }
    
    fileprivate var collectionViewIsUpdateing = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        replyTextView.resignFirstResponder()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        postButton.isHidden = replyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if replyTextView.superview == nil {
            replyInputContainer.addSubview(replyTextView)
            
            replyTextView.accessibilityIdentifier = "ReplyText"
            
            replyTextView.snp.makeConstraints { (make) in
                self.replyTextViewHeightConstraint = make.height.equalTo( self.heightForTextView()).constraint
                make.left.equalTo(replyInputContainer).offset(leftTextViewOffset)
                make.right.equalTo(postButton).inset(rightTextViewOffset + postButton.frame.size.width)
                make.top.equalTo(replyInputContainer).offset(topTextViewOffset)
                make.bottom.equalTo(replyInputContainer).offset(-topTextViewOffset)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        replyTextView.resignFirstResponder()
        hideHUD()
        super.viewWillDisappear(animated)
    }
    
    // MARK: Internal
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.refresh()
    }

    func configCollecionView() {
        collectionView.alwaysBounceVertical = true
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
        replyTextView.autocorrectionType = .no
    }
    
    func heightForTextView() -> CGFloat {
        return UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? replyViewHeightForIPhone5 : replyViewHeight
    }
    
    fileprivate func scrollTableToBottom() {
        if  output.numberOfItems() > 1 {
            collectionView.scrollToItem(at: IndexPath(row: output.numberOfItems() - 1, section: RepliesSections.replies.rawValue), at: .bottom, animated: true)
        }
    }
    
    func lockUI() {
        view.isUserInteractionEnabled = false
        showHUD()
    }
    
    func unlockUI() {
        refreshControl.endRefreshing()
        view.isUserInteractionEnabled = true
        hideHUD()
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
    
    func reloadCommentCell() {
        collectionView.reloadItems(at: [IndexPath(item: 0, section: RepliesSections.comment.rawValue)])
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
        if output.numberOfItems() > 1 {
            collectionView.reloadItems(at: [IndexPath(item: output.numberOfItems() - 2, section: RepliesSections.replies.rawValue)])
        }
        scrollTableToBottom()
        replyTextView.text = ""
        postButton.isHidden = true
        replyTextViewHeightConstraint.update(offset:  self.heightForTextView())
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseID, for: indexPath) as! CommentCell
            let configurator = CommentCellModuleConfigurator()
            configurator.configure(cell: cell, comment: output.mainComment(), navigationController: self.navigationController, moduleOutput: output as! CommentCellModuleOutout)
            cell.configure(comment: output.mainComment())
            cell.repliesButton.isHidden = true
            cell.apply(theme: theme)
            return cell
        case RepliesSections.loadMore.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.reuseID, for: indexPath) as! LoadMoreCell
            cell.configure(viewModel: output.loadCellModel())
            cell.apply(theme: theme)
            cell.delegate = self
            return cell
            case RepliesSections.replies.rawValue:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReplyCell.reuseID, for: indexPath) as! ReplyCell
                let config = ReplyCellModuleConfigurator()
                config.configure(cell: cell, reply: output.reply(index: indexPath.row), navigationController: self.navigationController, moduleOutput: self.output as? ReplyCellModuleOutput)
                cell.tag = indexPath.row
                cell.apply(theme: theme)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ReplyCell else {
            return
        }
        
        cell.separator.isHidden = indexPath.row == output.numberOfItems() - 1 && indexPath.section == RepliesSections.replies.rawValue
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
            prototypeCommentCell.configure(comment: output.mainComment())
            return prototypeCommentCell.cellSize()
        case RepliesSections.loadMore.rawValue:
            return CGSize(width: UIScreen.main.bounds.width, height: output.loadCellModel().cellHeight)
        case RepliesSections.replies.rawValue:
            prototypeReplyCell.configure(reply: output.reply(index: indexPath.row))
            return prototypeReplyCell.cellSize()
        default:
            return CGSize()
        }
    }
}

extension CommentRepliesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        replyTextViewHeightConstraint.update(offset: textView.text.count > 0 ? replyTextView.contentSize.height : self.heightForTextView())
        view.layoutIfNeeded()
        postButton.isHidden = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollTableToBottom()
    }
    
}
