//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellClass: T.Type = T.self) {
        let bundle = Bundle(for: cellClass.self)
        if bundle.path(forResource: cellClass.reuseID, ofType: "nib") != nil {
            let nib = UINib(nibName: cellClass.reuseID, bundle: bundle)
            register(nib, forCellReuseIdentifier: cellClass.reuseID)
        } else {
            register(cellClass.self, forCellReuseIdentifier: cellClass.reuseID)
        }
    }
    
    func indexPath(for view: UIView) -> IndexPath? {
        let location = view.convert(CGPoint.zero, to: self)
        return indexPathForRow(at: location)
    }
}
