//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PostDetailViewController: BaseViewController, PostDetailViewInput {

    var output: PostDetailViewOutput!

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaButton: UIButton!
    
    fileprivate var photo: Photo?
    fileprivate let imagePikcer = ImagePicker()
    
//    var footer: CommentInputView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: PostDetailViewInput
    func setupInitialState() {
        imagePikcer.delegate = self
        configTableView()
        configTextView()
    }
    
    func configTableView() {
        tableView.register(UINib(nibName: CommentCell.identifier, bundle: Bundle(for: CommentCell.self)), forCellReuseIdentifier: CommentCell.identifier)
        
        tableView.estimatedRowHeight = CommentCell.defaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reload() {
        tableView.reloadData()
        let indexPath = IndexPath(row: output.numberOfItems() - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
    }
}

extension PostDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        cell.config(comment: output.commentForPath(path: indexPath))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfItems()
    }
}

extension PostDetailViewController: UITableViewDelegate {
}

extension PostDetailViewController: CommentCellDelegate {
    func like(cell: CommentCell) {
        //        let comment = output.commentForPath(path: tableView.indexPath(for: cell)!)
        //        if comment.liked {
        //
        //        } else {
        //
        //        }
    }
    
    func toReplies() {
        
    }
    
    func mediaLoaded() {
        tableView.reloadData()
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
        self.photo = nil
        mediaButton.setImage( UIImage(asset: .placeholderPostNoimage), for: .normal)
    }
}
