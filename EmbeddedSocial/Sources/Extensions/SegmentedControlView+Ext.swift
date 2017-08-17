//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

extension SegmentedControlView {
    func configureForUserProfileModule(superview: UIView, onRecent: @escaping () -> Void, onPopular: @escaping () -> Void) {
        setSegments([
            SegmentedControlView.Segment(title: L10n.UserProfile.Button.recentPosts, action: { onRecent() }),
            SegmentedControlView.Segment(title: L10n.UserProfile.Button.popularPosts, action: { onPopular() })
            ])
        selectSegment(0)
        isSeparatorHidden = false
        separatorColor = Palette.extraLightGrey
        
        superview.addSubview(self)
        snp.makeConstraints { make in
            make.left.equalTo(superview)
            make.top.equalTo(superview)
            make.width.equalTo(superview)
            make.height.equalTo(Constants.UserProfile.filterHeight)
        }
    }
}
