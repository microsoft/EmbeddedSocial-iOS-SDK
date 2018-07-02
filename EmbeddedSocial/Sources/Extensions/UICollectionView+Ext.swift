//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionReusableView>(itemClass: T.Type = T.self) {
        let className = String(describing: itemClass.self)
        let bundle = Bundle(for: itemClass.self)
        if bundle.path(forResource: className, ofType: "nib") != nil {
            let nib = UINib(nibName: className, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: itemClass.reuseID)
        } else {
            register(itemClass.self, forCellWithReuseIdentifier: itemClass.reuseID)
        }
    }
}
