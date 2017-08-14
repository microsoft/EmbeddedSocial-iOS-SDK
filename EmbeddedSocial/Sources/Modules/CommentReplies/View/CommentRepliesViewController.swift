//
//  CommentRepliesCommentRepliesViewController.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class CommentRepliesViewController: UIViewController, CommentRepliesViewInput {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var replyTextView: UITextView!
    
    var output: CommentRepliesViewOutput!

    @IBOutlet weak var tableView: UITableView!
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configTableView()
    }

    func configTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: ReplyCell.reuseID, bundle: Bundle(for: ReplyCell.self)), forCellReuseIdentifier: ReplyCell.reuseID)
        tableView.estimatedRowHeight = ReplyCell.defaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func postReply(_ sender: Any) {
    }

    // MARK: CommentRepliesViewInput
    func setupInitialState() {
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

extension CommentRepliesViewController: UITableViewDelegate {
    
}

extension CommentRepliesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfItems()
    }
}
