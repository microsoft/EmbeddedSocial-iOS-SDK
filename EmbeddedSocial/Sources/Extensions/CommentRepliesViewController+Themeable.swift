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
        
        replyInputContainer.backgroundColor = palette.contentBackground
        
        let attrs: [String: Any] = [NSForegroundColorAttributeName: palette.textPlaceholder, NSFontAttributeName: AppFonts.medium]
        replyTextView.textColor = palette.textPrimary
        replyTextView.attributedPlaceholder = NSAttributedString(string: L10n.PostDetails.commentPlaceholder, attributes: attrs)
        replyTextView.font = AppFonts.medium
        replyTextView.backgroundColor = palette.contentBackground
        
        refreshControl.tintColor = palette.loadingIndicator
    }
}
