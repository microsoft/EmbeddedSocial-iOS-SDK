//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ProfileSummaryView: UIView {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    @IBOutlet fileprivate weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = L10n.Common.Placeholder.unknown
            nameLabel.font = AppFonts.bold.large
        }
    }
    
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.text = L10n.Common.Placeholder.notSpecified
            detailsLabel.font = AppFonts.medium
        }
    }
    
    @IBOutlet fileprivate weak var followersButton: UIButton! {
        didSet {
            let title = attributedString(L10n.ProfileSummary.Button.followers, withBoldNumber: 0)
            followersButton.setAttributedTitle(title, for: .normal)
            followersButton.titleLabel?.font = AppFonts.small
        }
    }
    
    @IBOutlet fileprivate weak var editButton: UIButton! {
        didSet {
            editButton.setTitle(L10n.ProfileSummary.Button.edit, for: .normal)
            editButton.titleLabel?.font = AppFonts.small
            editButton.isHidden = true
        }
    }
    
    @IBOutlet fileprivate weak var followingButton: UIButton! {
        didSet {
            let title = attributedString(L10n.ProfileSummary.Button.following, withBoldNumber: 0)
            followingButton.setAttributedTitle(title, for: .normal)
            followingButton.titleLabel?.font = AppFonts.small
        }
    }
    
    @IBOutlet fileprivate weak var followButton: UIButton! {
        didSet {
            followButton.setTitle(nil, for: .normal)
            followButton.isHidden = true
        }
    }
    
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
    
    var followersCount: Int = 0 {
        didSet {
            let title = attributedString(L10n.ProfileSummary.Button.followers, withBoldNumber: followersCount)
            followersButton.setAttributedTitle(title, for: .normal)
        }
    }
    
    var followingCount: Int = 0 {
        didSet {
            let title = attributedString(L10n.ProfileSummary.Button.following, withBoldNumber: followingCount)
            followingButton.setAttributedTitle(title, for: .normal)
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
        detailsLabel.text = user.bio ?? L10n.Common.Placeholder.notSpecified
        imageView.setPhotoWithCaching(user.photo, placeholder: UIImage(asset: AppConfiguration.shared.theme.assets.userPhotoPlaceholder))
        
        followersCount = user.followersCount
        followingCount = user.followingCount
        
        editButton.isHidden = !user.isMe
        followButton.isHidden = user.isMe

        configure(followStatus: user.followerStatus)
    }
    
    func configure(followStatus: FollowStatus?) {
        self.followStatus = followStatus
        
        if let style = followStatus?.buttonStyle {
            followButton.apply(style: style)
        }
    }
    
    private func attributedString(_ inputString: String, withBoldNumber number: Int) -> NSAttributedString {
        let font = AppFonts.small
        let boldFont = AppFonts.bold.small
        let textColor = theme?.palette.accent ?? Palette.green
        
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

extension ProfileSummaryView: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        
        backgroundColor = palette.topicBackground
        
        nameLabel.textColor = palette.textPrimary
        detailsLabel.textColor = palette.textPrimary
        
        followersButton.setTitleColor(palette.accent, for: .normal)
        editButton.setTitleColor(palette.accent, for: .normal)
        followingButton.setTitleColor(palette.accent, for: .normal)
        followButton.setTitleColor(palette.accent, for: .normal)
    }
}
