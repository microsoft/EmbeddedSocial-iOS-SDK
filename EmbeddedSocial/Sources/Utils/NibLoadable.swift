//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol NibLoadable {
    static var nib: UINib { get }
}

extension UITableViewCell: NibLoadable {
    class var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
