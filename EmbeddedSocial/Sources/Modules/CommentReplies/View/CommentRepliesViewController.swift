//
//  CommentRepliesCommentRepliesViewController.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

enum RepliesSections: Int {
    case comment = 0
    case replies
    case sectionsCount
}

class CommentRepliesViewController: BaseViewController, CommentRepliesViewInput {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var replyTextViewHeightConstraint: NSLayoutConstraint!
    
    var output: CommentRepliesViewOutput!

    fileprivate var isNewDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configTableView()
        configTextView()
    }

    func configTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: ReplyCell.reuseID, bundle: Bundle(for: ReplyCell.self)), forCellReuseIdentifier: ReplyCell.reuseID)
        tableView.register(UINib(nibName: CommentCell.reuseID, bundle: Bundle(for: CommentCell.self)), forCellReuseIdentifier: CommentCell.reuseID)
        tableView.estimatedRowHeight = ReplyCell.defaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configTextView() {
        replyTextView.delegate = self
        replyTextView.layer.borderWidth = 1
        replyTextView.layer.borderColor = UIColor.lightGray.cgColor
        replyTextView.layer.cornerRadius = 1
    }
    
    func reloadReplies() {
        tableView.reloadSections(IndexSet(integer: RepliesSections.replies.rawValue), with: .none)
    }

    
    @IBAction func postReply(_ sender: Any) {
        output.postReply(text: replyTextView.text)
    }
    
    // MARK: CommentRepliesViewInput
    func setupInitialState() {
    }
    
    func reloadTable() {
        self.isNewDataLoading = false
        tableView.reloadData()
    }
}

extension CommentRepliesViewController: UITableViewDelegate {
    
}

extension CommentRepliesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case RepliesSections.comment.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseID, for: indexPath) as! CommentCell
            cell.config(commentView: output.mainComment())
            return cell
        case RepliesSections.replies.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReplyCell.reuseID, for: indexPath) as! ReplyCell
            if  output.numberOfItems() > indexPath.row + 1 && isNewDataLoading == false {
                isNewDataLoading = true
//                output.fetchMore()
            }
            return cell
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case RepliesSections.comment.rawValue:
            return 1
        case RepliesSections.replies.rawValue:
            return output.numberOfItems()
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RepliesSections.sectionsCount.rawValue
    }
}

extension CommentRepliesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        replyTextViewHeightConstraint.constant = replyTextView.contentSize.height
        view.layoutIfNeeded()
        postButton.isHidden = textView.text.isEmpty
    }
    
}
