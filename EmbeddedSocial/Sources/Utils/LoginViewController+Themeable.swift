//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension LoginViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let theme = theme else {
            return
        }
        let palette = theme.palette
        view.backgroundColor = palette.contentBackground
    }
}
