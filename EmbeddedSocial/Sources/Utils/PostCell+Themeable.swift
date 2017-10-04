//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension PostCell: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        
        postTitle.textColor = palette.textPrimary
        postText.textColor = palette.textPrimary
        likedCount.textColor = palette.topicSecondaryText
        commentedCount.textColor = palette.topicSecondaryText
        userName.textColor = palette.textPrimary
        postCreation.textColor = palette.topicSecondaryText
        backgroundColor = palette.topicBackground
        container.backgroundColor = palette.topicBackground
    }
}
