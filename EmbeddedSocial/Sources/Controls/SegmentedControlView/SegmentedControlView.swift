//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SegmentedControlView: UIView {
    
    @IBOutlet fileprivate weak var segmentedControl: UISegmentedControl!
    
    private var segments: [Segment] = []
    
    @IBOutlet fileprivate weak var separatorView: UIView! {
        didSet {
            separatorView.isHidden = true
        }
    }
    
    var isSeparatorHidden: Bool = true {
        didSet {
            separatorView.isHidden = isSeparatorHidden
        }
    }
    
    var separatorColor: UIColor? = nil {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }
    
    var isEnabled: Bool {
        get {
            return segmentedControl.isEnabled
        }
        set {
            segmentedControl.isEnabled = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        segmentedControl.tintColor = Palette.green
    }
    
    func setSegments(_ segments: [Segment]) {
        segmentedControl.removeAllSegments()
        
        for (index, segment) in segments.enumerated() {
            segmentedControl.insertSegment(withTitle: segment.title, at: index, animated: false)
        }
        
        self.segments = segments
    }
    
    func selectSegment(_ segment: Int) {
        guard segment >= 0 && segment < segments.count else {
            return
        }
        segmentedControl.selectedSegmentIndex = segment
    }
    
    @IBAction private func onSegmentSwitch(_ sender: UISegmentedControl) {
        guard sender.selectedSegmentIndex < segments.count else {
            return
        }
        
        segments[sender.selectedSegmentIndex].action?()
    }
}

extension SegmentedControlView {
    struct Segment {
        let title: String?
        let action: (() -> Void)?
    }
}
