//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class ActivityNotificationLabel: UIView {
    
    struct Style {
        static let valuePadding = CGFloat(3)
    }
    
    let counterLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = NSTextAlignment.center
        view.textColor = UIColor.white
        view.adjustsFontSizeToFitWidth = true
        view.baselineAdjustment = UIBaselineAdjustment.alignCenters
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCountText(_ text: String?) {
        counterLabel.isHidden = (text == nil)
        counterLabel.text = text
        counterLabel.sizeToFit()
    }
    
    private func setup() {
        backgroundColor = UIColor.darkGray
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(counterLabel)
        
        let padding = ActivityNotificationLabel.Style.valuePadding
        
        counterLabel.snp.makeConstraints {
            
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview().inset(UIEdgeInsetsMake(padding,
                                                               padding,
                                                               padding,
                                                               padding))
        }
        
    }
}
