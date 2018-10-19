//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

extension UIViewController {
    
    func removeChildController(_ controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    func addChildController(_ controller: UIViewController, containerView: UIView, pinToEdges: Bool = true) {
        controller.willMove(toParent: nil)

        addChild(controller)
        
        containerView.addSubview(controller.view)
        
        if pinToEdges {
            controller.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        controller.didMove(toParent: self)
    }
    
    func addChildController(_ controller: UIViewController) {
        controller.willMove(toParent: nil)
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
