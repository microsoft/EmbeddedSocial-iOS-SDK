//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ProfileSummaryView: UIView {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    @IBOutlet fileprivate weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = Constants.Placeholder.unknown
            nameLabel.font = Fonts.bold.large
            nameLabel.textColor = Palette.black
        }
    }
    
    @IBOutlet fileprivate weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.text = Constants.Placeholder.notSpecified
            detailsLabel.font = Fonts.medium
            detailsLabel.textColor = Palette.black
        }
    }
    
    @IBOutlet fileprivate weak var followersButton: UIButton! {
        didSet {
            followersButton.setAttributedTitle(attributedString("followers", withBoldNumber: 0), for: .normal)
            followersButton.setTitleColor(Palette.green, for: .normal)
            followersButton.titleLabel?.font = Fonts.small
        }
    }
    
    @IBOutlet fileprivate weak var editButton: UIButton! {
        didSet {
            editButton.setTitle("Edit profile", for: .normal)
            editButton.setTitleColor(Palette.green, for: .normal)
            editButton.titleLabel?.font = Fonts.small
        }
    }
    
    @IBOutlet fileprivate weak var followingButton: UIButton! {
        didSet {
            followingButton.setAttributedTitle(attributedString("following", withBoldNumber: 0), for: .normal)
            followingButton.setTitleColor(Palette.green, for: .normal)
            followingButton.titleLabel?.font = Fonts.small
        }
    }
    
    @IBOutlet fileprivate weak var followButton: UIButton!
    
    var onFollowers: (() -> Void)?
    
    var onFollowing: (() -> Void)?
    
    var onEdit: (() -> Void)?
    
    var onFollow: ((FollowStatus) -> Void)?
    
    private var followStatus: FollowStatus?
    
    var isLoadingFollowStatus: Bool = false {
        didSet {
            followButton.setEnabledUpdatingOpacity(!isLoadingFollowStatus)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.makeCircular()
    }
    
    func configure(user: User) {
        nameLabel.text = user.fullName
        detailsLabel.text = user.bio ?? Constants.Placeholder.notSpecified
        imageView.setPhotoWithCaching(user.photo, placeholder: UIImage(asset: .userPhotoPlaceholder))
        
        followersButton.setAttributedTitle(attributedString("followers", withBoldNumber: user.followersCount), for: .normal)
        followingButton.setAttributedTitle(attributedString("following", withBoldNumber: user.followingCount), for: .normal)
        
        editButton.isHidden = !user.isMe
        followButton.isHidden = user.isMe
        
        configure(followingStatus: user.followingStatus)
    }
    
    func configure(followingStatus: FollowStatus?) {
        self.followStatus = followingStatus
        
        if let style = followingStatus?.buttonStyle {
            followButton.apply(style: style)
        }
    }
    
    private func attributedString(_ inputString: String, withBoldNumber number: Int) -> NSAttributedString {
        let font = Fonts.small
        let boldFont = Fonts.bold.small
        let textColor = Palette.green
        
        let numberAttrs: [String: Any] = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: textColor]
        let stringAttrs: [String: Any] = [NSFontAttributeName: font, NSForegroundColorAttributeName: textColor]
        
        let str = NSMutableAttributedString(string: "\(number)", attributes: numberAttrs)
        str.append(NSAttributedString(string: " \(inputString)", attributes: stringAttrs))
        
        return str
    }
    
    @IBAction private func onFollowers(_ sender: UIButton) {
        onFollowers?()
    }
    
    @IBAction private func onFollowing(_ sender: UIButton) {
        onFollowing?()
    }
    
    @IBAction private func onEdit(_ sender: UIButton) {
        onEdit?()
    }
    
    @IBAction private func onFollow(_ sender: UIButton) {
        guard let followStatus = followStatus else {
            return
        }
        onFollow?(followStatus)
    }
}
