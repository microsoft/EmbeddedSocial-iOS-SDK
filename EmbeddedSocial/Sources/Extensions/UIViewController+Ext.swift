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
    
    func addChildController(_ controller: UIViewController, containerView: UIView) {
        controller.willMove(toParentViewController: nil)

        addChildViewController(controller)
        
        containerView.addSubview(controller.view)
        controller.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        controller.didMove(toParentViewController: self)
    }
    
    func addChildController(_ controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
}
