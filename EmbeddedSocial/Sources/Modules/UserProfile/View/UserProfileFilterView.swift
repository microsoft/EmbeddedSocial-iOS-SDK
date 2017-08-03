//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class UserProfileFilterView: UIView {
    
    @IBOutlet fileprivate weak var segmentedControl: UISegmentedControl!
    
    var onRecent: (() -> Void)?
    
    var onPopular: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        segmentedControl.tintColor = Palette.green
//        segmentedControl.setTitle("Recent posts", forSegmentAt: Segment.recent.rawValue)
//        segmentedControl.setTitle("Popular posts", forSegmentAt: Segment.popular.rawValue)
    }
    
    func configure(segments: [Segment]) {
        for (index, segment) in segments.enumerated() {
            
        }
    }
    
    @IBAction private func onSegmentSwitch(_ sender: UISegmentedControl) {
//        guard let segment = Segment(rawValue: sender.selectedSegmentIndex) else {
//            return
//        }
//        
//        switch segment {
//        case .recent:
//            onRecent?()
//        case .popular:
//            onPopular?()
//        }
    }
}

extension UserProfileFilterView {
    enum Segment {
        case recent(String, () -> Void)
        case popular(String, () -> Void)
    }
}
