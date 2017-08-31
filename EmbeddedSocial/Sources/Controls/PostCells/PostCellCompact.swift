//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class PostCellCompact: UICollectionViewCell, PostCellProtocol {
    
    weak var collectionView: UICollectionView!
    @IBOutlet weak var postImage: UIImageView!
    
    func configure(with data: PostViewModel, collectionView: UICollectionView?) {
        
        self.collectionView = collectionView
        
        if data.postImageUrl == nil {
            postImage.image = postImagePlaceholder
        } else {
            postImage.setPhotoWithCaching(Photo(url: data.postImageUrl), placeholder: postImagePlaceholder)
        }
    }
    
    lazy var postImagePlaceholder: UIImage = {
        return UIImage(asset: Asset.placeholderPostNoimage)
    }()
    
    func indexPath() -> IndexPath {
        return collectionView.indexPath(for: self)!
    }
    
    override func awakeFromNib() {
        self.contentView.addSubview(postImage)
    }
    
}
