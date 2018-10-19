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
        tintColor = palette.accent
        setTitleTextAttributes([.foregroundColor: palette.controlHighlightedTitle], for: .selected)
        setTitleTextAttributes([.foregroundColor: palette.accent], for: .normal)
    }
}
