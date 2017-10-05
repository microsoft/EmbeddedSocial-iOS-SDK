//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension CommentCell: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        backgroundColor = .clear
        postedTimeLabel.textColor = palette.textSecondary
        separator.backgroundColor = palette.separator
        commentTextLabel.textColor = palette.textPrimary
        userName.textColor = palette.textPrimary
        likesCountButton.setTitleColor(palette.textPrimary, for: .normal)
        repliesCountButton.setTitleColor(palette.textPrimary, for: .normal)
        separator.backgroundColor = palette.separator
    }
}
