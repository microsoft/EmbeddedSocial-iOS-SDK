//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension FollowRequestCell {
    
    func configure(item: FollowRequestItem, tableView: UITableView, theme: Theme? = SocialPlus.theme, onAction: ActivityCellBlock?) {
        profileImage.setPhotoWithCaching(item.user.photo, placeholder: nil)
        profileName.text = item.user.fullName
        indexPath = { [weak tableView] cell in
            return tableView?.indexPath(for: cell)
        }
        self.onAction = onAction
        
        profileName.textColor = theme?.palette.textPrimary
        backgroundColor = theme?.palette.contentBackground
    }
}
