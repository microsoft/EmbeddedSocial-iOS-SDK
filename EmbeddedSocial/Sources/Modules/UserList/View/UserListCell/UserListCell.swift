//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class UserListCell: UITableViewCell {

    @IBOutlet weak fileprivate var profileImageView: UIImageView!
    
    @IBOutlet weak fileprivate var actionButton: UIButton!
    
    @IBOutlet weak fileprivate var nameLabel: UILabel!
    
    fileprivate var primaryAction: ((UserListItem) -> Void)?
    
    fileprivate var item: UserListItem?
    
    var isLoading: Bool = false {
        didSet {
            actionButton.setEnabledUpdatingOpacity(!isLoading)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        nameLabel.font = Fonts.medium
        nameLabel.textColor = Palette.black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        primaryAction = nil
        item = nil
        actionButton.isHidden = false
    }
    
    @IBAction private func onPrimaryAction(_ sender: UIButton) {
        if let item = item {
            primaryAction?(item)
        }
    }
}

extension UserListCell {
    func configure(_ item: UserListItem) {
        self.item = item

        let user = item.user
        
        profileImageView.setPhotoWithCaching(user.photo, placeholder: UIImage(asset: Asset.userPhotoPlaceholder))
        profileImageView.setNeedsLayout()
        profileImageView.layoutIfNeeded()
        profileImageView.makeCircular()

        nameLabel.text = user.fullName
        
        actionButton.isHidden = item.isActionButtonHidden

        if let buttonStyle = user.followerStatus?.buttonStyle {
            actionButton.apply(style: buttonStyle)
            primaryAction = item.action
        }
    }
}
