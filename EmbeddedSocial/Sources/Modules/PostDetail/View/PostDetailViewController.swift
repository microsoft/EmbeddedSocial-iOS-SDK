//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SVProgressHUD
import SKPhotoBrowser

fileprivate enum TableSections: Int {
    case post = 0
    case comments
    case sectionsCount
}

class PostDetailViewController: BaseViewController, PostDetailViewInput {

    var output: PostDetailViewOutput!
    
    //constants
    fileprivate let reloadDelay = 0.2
    fileprivate let commentViewHeight: CGFloat = 35
    
    fileprivate var isNewDataLoading = false

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
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
        tableView.addSubview(self.refreshControl)
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
        output.viewIsReady()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.refresh()
    }

    // MARK: PostDetailViewInput
    func setupInitialState() {
        imagePikcer.delegate = self
        mediaButton.isEnabled = false
        configTableView()
        configTextView()
    }
    
    func updateFeed(view: UIView, scrollType: CommentsScrollType) {
        commentTextView.isEditable = true
        mediaButton.isEnabled = true
        postView = view
        reloadTable(scrollType: scrollType)
    }

    private func configTableView() {
        prototypeCell = UINib(nibName: CommentCell.identifier, bundle: Bundle(for: CommentCell.self)).instantiate(withOwner: nil, options: nil).first as? CommentCell
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: CommentCell.identifier, bundle: Bundle(for: CommentCell.self)), forCellReuseIdentifier: CommentCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadTable(scrollType: CommentsScrollType) {
        refreshControl.endRefreshing()
        self.isNewDataLoading = false
        tableView.reloadData()
        switch scrollType {
            case .bottom:
                DispatchQueue.main.asyncAfter(deadline: .now() + reloadDelay) {
                    self.scrollTableToBottom()
                }
            default: break
        }
    }
    
    fileprivate func scrollTableToBottom() {
        if  output.numberOfItems() > 1 {
            tableView.scrollToRow(at: IndexPath(row: output.numberOfItems() - 1, section: TableSections.comments.rawValue), at: .bottom, animated: true)
        }
    }
    
    func refreshCell(index: Int) {
        tableView.reloadRows(at: [IndexPath.init(row: index, section: TableSections.comments.rawValue)], with: .none)
    }
    
    func postCommentSuccess() {
        clearImage()
        commentTextViewHeightConstraint.constant = commentViewHeight
        commentTextView.text = nil
        postButton.isHidden = true
        SVProgressHUD.dismiss()
        view.layoutIfNeeded()
        tableView.reloadData()
        scrollTableToBottom()
    }
    
    func postCommentFailed(error: Error) {
        postButton.isHidden = false
        SVProgressHUD.dismiss()
    }
    
    func clearImage() {
        photo = nil
        imagePikcer.imageWasSelected = false
        mediaButton.setImage( UIImage(asset: .placeholderPostNoimage), for: .normal)
    }
    
    func configTextView() {
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

extension PostDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case TableSections.post.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.addSubview(postView!)
            return cell
        case TableSections.comments.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            cell.tag = indexPath.row
            cell.config(commentView: output.commentViewModel(index: indexPath.row))
            if  output.numberOfItems() - 1 < indexPath.row + 2  && isNewDataLoading == false {
                isNewDataLoading = true
                output.fetchMore()
            }
            return cell
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TableSections.post.rawValue:
            if postView == nil {
                return 0
            }
            return 1
            
        case TableSections.comments.rawValue:
            return output.numberOfItems()
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSections.sectionsCount.rawValue
    }
}

extension PostDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case TableSections.post.rawValue:
            return output.feedModuleHeight()
        case TableSections.comments.rawValue:
            prototypeCell?.config(commentView: output.commentViewModel(index: indexPath.row))
            return prototypeCell!.cellHeight()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == TableSections.comments.rawValue {
            output.openReplies(index: indexPath.row)
        }
    }
}

extension PostDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        commentTextViewHeightConstraint.constant = commentTextView.contentSize.height
        view.layoutIfNeeded()
        postButton.isHidden = textView.text.isEmpty
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
