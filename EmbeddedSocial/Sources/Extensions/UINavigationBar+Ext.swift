//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension UINavigationBar {
    func disableTopItemButtons() {
        topItem?.leftBarButtonItems?.forEach { $0.isEnabled = false }
        topItem?.rightBarButtonItems?.forEach { $0.isEnabled = false }
    }
    
    func enabledTopItemButtons() {
        topItem?.leftBarButtonItems?.forEach { $0.isEnabled = true }
        topItem?.rightBarButtonItems?.forEach { $0.isEnabled = true }
    }
}
