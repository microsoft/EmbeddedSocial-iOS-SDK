//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class BarButtonItemWithTarget: UIBarButtonItem {
    
    var onTap: (() -> Void)? {
        didSet {
            if let control = customView as? UIControl {
                if #available(iOS 9.0, *) {
                    control.addTarget(self, action: #selector(tapped(_:)), for: .primaryActionTriggered)
                } else {
                    control.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
                }
            }
            else {
                target = self
                action = #selector(tapped(_:))
            }
        }
    }
    
    @objc private func tapped(_ sender: AnyObject) {
        onTap?()
    }
}
