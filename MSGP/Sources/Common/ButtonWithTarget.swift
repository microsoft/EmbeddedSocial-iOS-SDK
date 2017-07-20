//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class ButtonWithTarget: UIButton {
    
    var onPrimaryActionTriggered: (() -> Void)? {
        didSet {
            if #available(iOS 9.0, *) {
                addTarget(self, action: #selector(tapped(_:)), for: .primaryActionTriggered)
            } else {
                addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func tapped(_ sender: AnyObject) {
        onPrimaryActionTriggered?()
    }
}
