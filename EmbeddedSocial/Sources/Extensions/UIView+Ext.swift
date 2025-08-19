//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UIView {
    
    func makeCircular() {
        layer.cornerRadius = bounds.height / 2.0
        layer.masksToBounds = true
    }
    
    func embed(view: UIView) {
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
