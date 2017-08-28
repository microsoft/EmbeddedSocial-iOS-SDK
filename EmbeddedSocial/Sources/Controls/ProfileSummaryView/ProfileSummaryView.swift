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
            nameLabel.font = Fonts.bold.large
            nameLabel.textColor = Palette.black
        }
    }
    
    @IBOutlet weak var detailsTextView: UITextView! {
        didSet {
            detailsTextView.text = L10n.Common.Placeholder.notSpecified
            detailsTextView.font = Fonts.medium
            detailsTextView.textColor = Palette.black
        }
    }
    
    @IBOutlet fileprivate weak var followersButton: UIButton! {
        didSet {
            let title = attributedString(L10n.ProfileSummary.Button.followers, withBoldNumber: 0)
            followersButton.setAttributedTitle(title, for: .normal)
            followersButton.setTitleColor(Palette.green, for: .normal)
            followersButton.titleLabel?.font = Fonts.small
        }
    }
    
    @IBOutlet fileprivate weak var editButton: UIButton! {
        didSet {
            editButton.setTitle(L10n.ProfileSummary.Button.edit, for: .normal)
            editButton.setTitleColor(Palette.green, for: .normal)
            editButton.titleLabel?.font = Fonts.small
        }
    }
    
    @IBOutlet fileprivate weak var followingButton: UIButton! {
        didSet {
            let title = attributedString(L10n.ProfileSummary.Button.following, withBoldNumber: 0)
            followingButton.setAttributedTitle(title, for: .normal)
            followingButton.setTitleColor(Palette.green, for: .normal)
            followingButton.titleLabel?.font = Fonts.small
        }
    }
    
    @IBOutlet fileprivate weak var followButton: UIButton! {
        didSet {
            followButton.setTitle(nil, for: .normal)
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
        
        guard let superview = imageView.superview else {
            return
        }
        let intersection = imageView.frame.intersection(detailsTextView.frame)
        let convertedPaddedIntersection = detailsTextView
            .convert(intersection, from: superview)
            .insetBy(dx: -Constants.UserProfile.containerInset, dy: 0)
        let path = UIBezierPath(rect: convertedPaddedIntersection)
        detailsTextView.textContainer.exclusionPaths = [path]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.makeCircular()
    }
    
    func configure(user: User, isAnonymous: Bool) {
        nameLabel.text = user.fullName
        detailsTextView.text = user.bio ?? L10n.Common.Placeholder.notSpecified
        imageView.setPhotoWithCaching(user.photo, placeholder: UIImage(asset: .userPhotoPlaceholder))
        
        followersCount = user.followersCount
        followingCount = user.followingCount
        
        if isAnonymous {
            editButton.isHidden = true
            followButton.isHidden = true
        } else {
            editButton.isHidden = !user.isMe
            followButton.isHidden = user.isMe
        }

        configure(followStatus: user.followerStatus)
    }
    
    func configure(followStatus: FollowStatus?) {
        self.followStatus = followStatus
        
        if let style = followStatus?.buttonStyle {
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
