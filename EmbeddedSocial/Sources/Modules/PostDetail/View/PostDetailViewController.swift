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
    fileprivate let imagePikcer = ImagePicker()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: PostDetailViewInput
    func setupInitialState() {
        imagePikcer.delegate = self
        configPost()
        configTableView()
        configTextView()
    }
    
    
    func updateFeed(view: UIView) {
        postView = view
        tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .none)
    }

    func configTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: CommentCell.identifier, bundle: Bundle(for: CommentCell.self)), forCellReuseIdentifier: CommentCell.identifier)
        tableView.estimatedRowHeight = CommentCell.defaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate var feedModuleInput: FeedModuleInput!
    fileprivate var postView: UIView?
    
    func configPost() {
        // Module
        let configurator = FeedModuleConfigurator(cache: SocialPlus.shared.cache)
        configurator.configure(navigationController: self.navigationController!)

        feedModuleInput = configurator.moduleInput!
        let feedViewController = configurator.viewController!

        feedViewController.willMove(toParentViewController: self)
        addChildViewController(feedViewController)
        feedViewController.didMove(toParentViewController: self)

        let feed = FeedType.single(post: (output.post?.topicHandle)!)
        feedModuleInput.setFeed(feed)
        postView = feedViewController.view
    }
    
    func reloadTable() {
        self.isNewDataLoading = false
        tableView.reloadData()
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
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.cornerRadius = 1
    }
    
    @IBAction func mediaButtonPressed(_ sender: Any) {
        let options = ImagePicker.Options(title: Alerts.Titles.choose,
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
            cell.config(comment: output.comment(index: indexPath.row))
            cell.delegate = self
            if  output.numberOfItems() > indexPath.row + 1 && isNewDataLoading == false {
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
            return feedModuleInput.moduleHeight()
        case TableSections.comments.rawValue:
            return UITableViewAutomaticDimension
        default:
            return 0
        }
    }
}

extension PostDetailViewController: CommentCellDelegate {
    
    func openUser(index: Int) {
        output.openUser(index: index)
    }
    
    func like(index: Int) {
        let comment = output.comment(index: index)
        if comment.liked {
            output.unlikeComment(comment: comment)
        } else {
            output.likeComment(comment: comment)
        }
    }

    func toReplies() {
        
    }
    
    func mediaLoaded() {
        tableView.reloadData()
    }
    
    func photoPressed(image: UIImage, in cell: CommentCell) {
        let browser = SKPhotoBrowser(originImage: image, photos: [SKPhoto.photoWithImage(image)], animatedFromView: cell)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func commentOptionsPressed(index: Int) {
    }
}

extension PostDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        commentTextViewHeightConstraint.constant = commentTextView.contentSize.height
        view.layoutIfNeeded()
        postButton.isHidden = textView.text.isEmpty
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
