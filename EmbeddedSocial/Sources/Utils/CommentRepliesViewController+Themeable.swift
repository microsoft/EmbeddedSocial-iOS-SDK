//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension CommentRepliesViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        view.backgroundColor = palette.contentBackground
        collectionView.backgroundColor = palette.contentBackground
        postButton.setTitleColor(palette.controlHighlighted, for: .normal)
        replyTextView.textColor = palette.textPrimary
    }
}
