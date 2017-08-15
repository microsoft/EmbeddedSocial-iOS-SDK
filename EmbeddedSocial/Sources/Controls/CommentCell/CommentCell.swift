//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import UIKit

protocol CommentCellDelegate: class {
    func like(index: Int)
    func toReplies()
    func mediaLoaded()
    func photoPressed(image: UIImage, in cell: CommentCell)
    func commentOptionsPressed(index: Int)
    func openUser(index: Int)
}

class CommentCell: UITableViewCell {

    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var repliesCountButton: UIButton!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var mediaButtonHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    var delegate: CommentCellDelegate?
    
    private var formatter = DateFormatterTool()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarButton.imageView?.contentMode = .scaleAspectFill
    }
    
    static let identifier = "CommentCell"
    static let defaultHeight: CGFloat = 190

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(comment: Comment) {
        avatarButton.setPhotoWithCaching(Photo(uid: UUID().uuidString,
                                               url: comment.photoUrl,
                                               image: nil),
                                         placeholder: UIImage(asset: .userPhotoPlaceholder))
        repliesCountButton.setTitle("\(comment.totalReplies ) replies", for: .normal)
        likesCountButton.setTitle("\(comment.totalLikes ) likes", for: .normal)
        commentTextLabel.text = comment.text
        usernameLabel.text = "\(comment.firstName ?? "") \(comment.lastName ?? "")"
        if let url = comment.mediaUrl {
            mediaButton.imageView?.contentMode = .scaleAspectFill
            mediaButton.setPhotoWithCaching(Photo(uid: UUID().uuidString,
                                                  url: url,
                                                  image: nil),
                                            placeholder: UIImage(asset: .placeholderPostNoimage))
            mediaButtonHeightConstraint.constant = UIScreen.main.bounds.size.height/3
            
        } else {
            mediaButtonHeightConstraint.constant = 0
        }
        
        postedTimeLabel.text = comment.createdTime.map{ formatter.shortStyle.string(from: $0, to: Date()) }!
        likeButton.isSelected = comment.liked
        selectionStyle = .none
        contentView.layoutIfNeeded()
        
        // TODO: full fit
        
    }
    @IBAction func commentOptionsPressed(_ sender: Any) {
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.like(index: tag)
    }

    @IBAction func commentPressed(_ sender: Any) {
    }
    @IBAction func avatarPressed(_ sender: Any) {
        delegate?.openUser(index: tag)
    }
    
    @IBAction func mediaPressed(_ sender: Any) {
        delegate?.photoPressed(image: (mediaButton.imageView?.image)!, in: self)
    }
}
