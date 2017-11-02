//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class OfflineView: UILabel {
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    private let oldOSVersion = 10
    private let labelHeight: CGFloat = 30
    private let fontSize: CGFloat = 13
    
    func show(in controller: UIViewController) {
        
        if self.superview == nil {
            let offsetY = ProcessInfo().operatingSystemVersion.majorVersion > oldOSVersion ?  (controller.navigationController?.navigationBar.frame.height ?? 0) + statusBarHeight : 0
            self.frame = CGRect(x: 0, y: offsetY, width: UIScreen.main.bounds.size.width, height: labelHeight)
            self.textAlignment = .center
            self.text = L10n.Error.noInternetConnection
            self.font = UIFont.systemFont(ofSize: fontSize)
            self.backgroundColor = UIColor(red: 34/255 , green: 139/255, blue: 34/255, alpha: 1)
            self.textColor = .white
            controller.view.addSubview(self)
        }

    }
    
    func hide() {
        self.removeFromSuperview()
    }
}
