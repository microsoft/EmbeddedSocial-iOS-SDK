//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

extension UIViewController {
    
    func removeChildController(_ controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    func addChildController(_ content: UIViewController, containerView: UIView) {
        addChildViewController(content)
        
        containerView.addSubview(content.view)
        content.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        content.didMove(toParentViewController: self)
    }
}
