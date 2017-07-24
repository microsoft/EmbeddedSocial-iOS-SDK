//
//  TopicCell.swift
//  MSGP
//
//  Created by Igor Popov on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

struct TopicCellData {
    var userName: String
    var userPhoto: Photo
    var postTitle: String
    var postText: String
    var postCreation: String
    var postImage: Photo
}

class TopicCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var userPhoto: UIImageView! {
        didSet {
            userPhoto.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var postCreation: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var likedList: UILabel!
    
    @IBAction func onTapLike(_ sender: Any) {
        
    }
    
    @IBAction func onTapCommented(_ sender: Any) {
        
    }
    
    @IBAction func onTapPin(_ sender: Any) {
        
    }
    
    @IBAction func onTapExtra(_ sender: Any) {
        
    }
    
    @IBOutlet weak var likedCount: UILabel!
    @IBOutlet weak var commentedCount: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.layer.bounds.height / 2
    }
    
    func configure(with data: TopicCellData) {
        userPhoto.setPhotoWithCaching(data.userPhoto, placeholder: UIImage(asset: .userPhotoPlaceholder))
        userName.text = data.userName
        postTitle.text = data.postTitle
        postText.text = data.postText
        postCreation.text = data.postCreation
    }
//    
//    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
//        var frame = attributes.frame
//        frame.size.width = layoutAttributes.size.width
//        attributes.frame = frame
//        return attributes
//    }
}
