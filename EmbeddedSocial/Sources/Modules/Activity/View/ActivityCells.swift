//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

enum ActivityCellEvent: Int {
    case accept
    case reject
    case touch
}

typealias ActivityCellBlock = ((IndexPath, ActivityCellEvent) -> Void)

class ActivityBaseCell: UITableViewCell {

    var onAction: ActivityCellBlock?
    var indexPath: ((UITableViewCell) -> IndexPath?)!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.makeCircular()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.setPhotoWithCaching(nil, placeholder: nil)
        actionIcon.image = nil
        onAction = nil
    }
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let actionIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    func setup() {
        backgroundColor = Style.backgroundColor
        addSubview(profileImage)
        addSubview(actionIcon)
        
        profileImage.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Style.insets.left)
            $0.top.equalToSuperview().offset(Style.insets.top)
            $0.bottom.equalToSuperview().offset(Style.insets.bottom)
            $0.height.equalToSuperview().multipliedBy(Style.imagesHeightRatio).priority(.medium)
            $0.width.equalTo(profileImage.snp.height)
            $0.centerY.equalToSuperview()
        }
        
        actionIcon.snp.makeConstraints {
            $0.bottom.equalTo(profileImage)
            $0.right.equalTo(profileImage)
            $0.height.equalTo(Style.actionIconSize)
            $0.width.equalTo(actionIcon.snp.height)
        }
    }
}

class FollowRequestCell: ActivityBaseCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileName.text = nil
    }
    
    override func setup() {
        super.setup()
        
        addSubview(profileName)
        addSubview(acceptButton)
        addSubview(rejectButton)
        
        profileName.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.left.equalTo(profileImage.snp.right).offset(Style.ItemInterval)
        }
        
        rejectButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(Style.insets.right)
            $0.height.equalToSuperview().multipliedBy(Style.buttonsHeightRatio)
            $0.width.equalTo(rejectButton.snp.height)
        }
        
        acceptButton.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(Style.buttonsHeightRatio)
            $0.width.equalTo(acceptButton.snp.height).multipliedBy(Style.acceptButtonRatio)
            $0.right.equalTo(rejectButton.snp.left).offset(-Style.ItemInterval * 2)
            $0.centerY.equalTo(rejectButton)
        }
    }
    
    let profileName: UILabel = {
        let view = UILabel()
        view.font = Style.Fonts.normal
        return view
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(ActivityBaseCell.Style.Images.accept, for: UIControlState.normal)
        button.addTarget(self, action: #selector(onAccept), for: .touchUpInside)
        return button
    }()
    
    lazy var rejectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Style.Images.reject, for: UIControlState.normal)
        button.addTarget(self, action: #selector(onReject), for: .touchUpInside)
        return button
    }()
    
    var isLoading = false {
        didSet {
            rejectButton.setEnabledUpdatingOpacity(!isLoading)
            acceptButton.setEnabledUpdatingOpacity(!isLoading)
        }
    }
    
    @objc func onAccept() {
        guard let path = indexPath(self) else { return }
        
        onAction?(path, .accept)
    }
    
    @objc func onReject() {
        guard let path = indexPath(self) else { return }
        
        onAction?(path, .reject)
    }
}

class ActivityCell: ActivityBaseCell {

    let postText: UILabel = {
        let view = UILabel()
        view.numberOfLines = Style.numberOfLines
        return view;
    }()
    
    let postImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    @objc func onCellTouch() {
        guard let path = indexPath(self) else { return }
        onAction?(path, .touch)
    }
    
    lazy var touchItem: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(onCellTouch), for: .touchUpInside)
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postImage.setPhotoWithCaching(nil, placeholder: nil)
        postText.text = nil
        onAction = nil
    }
    
    override func setup() {
        super.setup()
        
        addSubview(postImage)
        addSubview(postText)
        addSubview(touchItem)
    
        postImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().offset(Style.insets.top)
            $0.bottom.equalToSuperview().offset(Style.insets.bottom)
            $0.right.equalToSuperview().offset(Style.insets.right)
            $0.height.equalToSuperview().multipliedBy(Style.imagesHeightRatio).priority(.medium)
            $0.width.equalTo(postImage.snp.height)
        }

        postText.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.left.equalTo(profileImage.snp.right).offset(Style.ItemInterval)
            $0.right.equalTo(postImage.snp.left).offset(-Style.ItemInterval)
        }

        // top view to take all actions
        touchItem.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

// MARK: Style

extension ActivityBaseCell {
 
    struct Style {
        static let insets = UIEdgeInsets(top: 15, left: 25, bottom: -15, right: -25)
        static var backgroundColor: UIColor { return SocialPlus.palette.contentBackground }
        static let paddingVertical = 15
        static let paddingHorizontal = 15
        static let ItemInterval = 10
        static let numberOfLines = 2
        static let imagesHeightRatio = 0.6
        static let buttonsHeightRatio = 0.18
        static let acceptButtonRatio = (65.0 / 48.0)
        static let actionIconSize = 20
        
        struct Fonts {
            static var normal: UIFont { return AppFonts.small }
            static var bold: UIFont { return AppFonts.bold.small }
            
            struct Attributes {
                
                static var time: [String: Any] {
                    return [
                        NSFontAttributeName: ActivityBaseCell.Style.Fonts.bold,
                        NSForegroundColorAttributeName: SocialPlus.palette.textPrimary
                    ]
                }
                
                static var normal: [String: Any] {
                    return [
                        NSFontAttributeName: ActivityBaseCell.Style.Fonts.bold,
                        NSForegroundColorAttributeName: SocialPlus.palette.textSecondary
                    ]
                }
            }
        }
        
        struct Images {
            static let accept = Asset.esAccept.image
            static let reject = Asset.esReject.image
            static let follow = Asset.esDecorFollow.image
            static let comment = Asset.esDecorComment.image
            static let like = Asset.esDecorLike.image
        }
    }
    
}
