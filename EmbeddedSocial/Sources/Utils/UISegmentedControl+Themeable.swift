//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UISegmentedControl: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        tintColor = palette.controlHighlighted
        setTitleTextAttributes([NSForegroundColorAttributeName: palette.controlHighlightedTitle], for: .selected)
        setTitleTextAttributes([NSForegroundColorAttributeName: palette.controlHighlighted], for: .normal)
    }
}
