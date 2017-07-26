//
//  ProfileSummaryView.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/26/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

enum UserRelation: Int {
    case me
    case notFollowing
    case following
    case pendingRequest
    
    var buttonStyle: UIButton.Style? {
        switch self {
        case .me: return nil
        case .notFollowing: return .follow
        case .following: return .following
        case .pendingRequest: return .pending
        }
    }
}

class ProfileSummaryView: UIView {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    @IBOutlet fileprivate weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = Fonts.bold.large
            nameLabel.textColor = Palette.black
        }
    }
    
    @IBOutlet fileprivate weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.font = Fonts.medium
            detailsLabel.textColor = Palette.black
        }
    }
    
    @IBOutlet fileprivate weak var followersButton: UIButton! {
        didSet {
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
            followingButton.setTitleColor(Palette.green, for: .normal)
            followingButton.titleLabel?.font = Fonts.small
        }
    }
    
    @IBOutlet fileprivate weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyles()
    }
    
    private func setupStyles() {
        backgroundColor = .yellow
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.makeCircular()
    }
    
    func configure(user: User, relation: UserRelation) {
        nameLabel.text = user.fullName
        detailsLabel.text = user.bio ?? Constants.Placeholder.notSpecified
        imageView.setPhotoWithCaching(user.photo, placeholder: UIImage(asset: .userPhotoPlaceholder))
        
        followersButton.setTitle("12 followers", for: .normal)
        followingButton.setTitle("16 followers", for: .normal)
        editButton.setTitle("16 followers", for: .normal)
        
        editButton.isHidden = relation != .me
        followButton.isHidden = relation == .me
        
        if let style = relation.buttonStyle {
            followButton.apply(style: style)
        }
    }
}
