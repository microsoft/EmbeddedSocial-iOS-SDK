//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class UserProfileHeaderView: UIView {
    
    var onRecent: (() -> Void)?
    var onPopular: (() -> Void)?
    
    lazy var summaryView: ProfileSummaryView = { [unowned self] in
        let summaryView = ProfileSummaryView.fromNib()
        self.addSubview(summaryView)
        
        summaryView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(summaryView.snp.width).dividedBy(Constants.UserProfile.summaryAspectRatio)
        }
        
        return summaryView
    }()
    
    lazy var filterView: SegmentedControlView = { [unowned self] in
        let filterView = SegmentedControlView.fromNib()
        filterView.setSegments([
            SegmentedControlView.Segment(title: "Recent posts", action: { [weak self] in self?.onRecent?() }),
            SegmentedControlView.Segment(title: "Popular posts", action: { [weak self] in self?.onPopular?() })
            ])
        filterView.selectSegment(0)
        filterView.isSeparatorHidden = false
        filterView.separatorColor = Palette.extraLightGrey
        
        self.addSubview(filterView)
        filterView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(self.summaryView.snp.bottom).offset(Constants.UserProfile.containerInset).priority(.low)
            make.width.equalTo(self)
            make.height.equalTo(Constants.UserProfile.filterHeight)
        }
        
        return filterView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        _ = summaryView
        _ = filterView
    }
}
