//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ThemePalette: NSObject {
    
    var contentBackground: UIColor!
    var navigationBarBackground: UIColor!
    var navigationBarTint: UIColor!
    var navigationBarTitle: UIColor!
    var controlUnhighlighted: UIColor!
    var controlHighlightedTitle: UIColor!
    var textPrimary: UIColor!
    var textSecondary: UIColor!
    var topicBackground: UIColor!
    var separator: UIColor!
    var textPlaceholder: UIColor!
    var loadingIndicator: UIColor!
    var topicsFeedBackground: UIColor!
    var tableGroupHeaderBackground: UIColor!
    var topicSecondaryText: UIColor!
    let accent: UIColor
    
    init(config: [String: Any], accentColor: UIColor) {
        accent = accentColor
        super.init()
        setup(with: config)
    }
    
    private func setup(with config: [String: Any]) {
        for (keypath, value) in config {
            if let string = value as? String {
                let color = UIColor(hexString: string)
                setValue(color, forKey: keypath)
            }
        }
    }
}
