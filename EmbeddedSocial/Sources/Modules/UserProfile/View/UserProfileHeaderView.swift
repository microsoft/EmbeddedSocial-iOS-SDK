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
            make.height.equalTo(Constants.UserProfile.summaryHeight).priority(.low)
            make.bottom.equalTo(self.filterView.snp.top).offset(-Constants.UserProfile.containerInset)
        }
        
        return summaryView
    }()
    
    lazy var filterView: SegmentedControlView = { [unowned self] in
        let filterView = SegmentedControlView.fromNib()
        filterView.setSegments([
            SegmentedControlView.Segment(title: L10n.UserProfile.Button.recentPosts,
                                         action: { [weak self] in self?.onRecent?() }),
            
            SegmentedControlView.Segment(title: L10n.UserProfile.Button.popularPosts,
                                         action: { [weak self] in self?.onPopular?() })
            ])
        filterView.selectSegment(Constants.UserProfile.recentSegment)
        filterView.isSeparatorHidden = false
        
        self.addSubview(filterView)
        filterView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(Constants.UserProfile.filterHeight)
            make.bottom.equalTo(self)
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

extension UserProfileHeaderView {
    
    func apply(theme: Theme?) {
        summaryView.theme = theme
        
        filterView.apply(theme: theme)
        summaryView.apply(theme: theme)
        
        backgroundColor = .clear
    }
}
