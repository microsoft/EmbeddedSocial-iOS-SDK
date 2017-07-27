//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
    
    var isCollapsed: Bool = false {
        didSet {
            
        }
    }
    
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
    @IBOutlet weak var postText: UITextView! {
        didSet {
            postText.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 5)
            postText.textContainer.lineFragmentPadding = 0
        }
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        clipsToBounds = true
    }
    
    func configure(with data: TopicCellData) {
        userPhoto.setPhotoWithCaching(data.userPhoto, placeholder: UIImage(asset: .userPhotoPlaceholder))
        userName.text = data.userName
        postTitle.text = data.postTitle
        postText.text = data.postText
        postCreation.text = data.postCreation

    }
}
