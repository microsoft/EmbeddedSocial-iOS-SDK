//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ThemePalette: NSObject {
    
    var contentBackground: UIColor!
    var navigationBarBackground: UIColor!
    var navigationBarTint: UIColor!
    var navigationBarTitle: UIColor!
    var controlHighlighted: UIColor!
    var controlUnhighlighted: UIColor!
    var controlHighlightedTitle: UIColor!
    var textPrimary: UIColor!
    var textSecondary: UIColor!
    var topicBackground: UIColor!
    var separator: UIColor!
    
    init(config: [String: Any]) {
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
