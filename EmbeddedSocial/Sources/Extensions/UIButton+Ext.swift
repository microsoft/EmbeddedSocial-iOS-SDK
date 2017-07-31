//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UIButton {
    
    static func makeButton(asset: Asset?, title: String? = nil, font: UIFont? = nil,
                           color: UIColor, action: (() -> Void)?) -> UIButton {
        let button = ButtonWithTarget(type: .system)
        if let asset = asset {
            button.setImage(UIImage(asset: asset), for: .normal)
        }
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.tintColor = color
        button.setTitleColor(color, for: .normal)
        button.onPrimaryActionTriggered = action
        button.sizeToFit()
        return button
    }
    
    func setEnabledUpdatingOpacity(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        alpha = isEnabled ? 1.0 : 0.5
    }
}
