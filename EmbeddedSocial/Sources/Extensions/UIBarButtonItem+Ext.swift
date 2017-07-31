//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UIBarButtonItem {
    convenience init(asset: Asset? = nil, title: String? = nil, font: UIFont? = nil,
                     color: UIColor, action: (() -> Void)? = nil) {
        let button = UIButton.makeButton(asset: asset, title: title, font: font, color: color, action: action)
        self.init(customView: button)
    }
}
