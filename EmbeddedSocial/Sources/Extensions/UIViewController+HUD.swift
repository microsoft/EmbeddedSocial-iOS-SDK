//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SVProgressHUD
import MBProgressHUD

extension UIViewController {
    
    func showHUD(in view: UIView = UIApplication.shared.keyWindow!, isBlocking: Bool = false) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.isUserInteractionEnabled = isBlocking
    }
    
    func hideHUD(in view: UIView = UIApplication.shared.keyWindow!) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
