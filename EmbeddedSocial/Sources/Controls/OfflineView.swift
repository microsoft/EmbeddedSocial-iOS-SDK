//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class OfflineView {
    
    private static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    private static let oldOSVersion = 10
    private static let labelHeight: CGFloat = 30
    private static let fontSize: CGFloat = 13
    private static var offlineLabel = UILabel()
    
    static func show(in controller: UIViewController) {
        if offlineLabel.superview == nil {
            let offsetY = ProcessInfo().operatingSystemVersion.majorVersion > oldOSVersion ?  (controller.navigationController?.navigationBar.frame.height ?? 0) + statusBarHeight : 0
            offlineLabel.frame = CGRect(x: 0, y: offsetY, width: UIScreen.main.bounds.size.width, height: labelHeight)
            offlineLabel.textAlignment = .center
            offlineLabel.text = L10n.Error.noInternetConnection
            offlineLabel.font = UIFont.systemFont(ofSize: fontSize)
            offlineLabel.backgroundColor = UIColor(red: 34/255 , green: 139/255, blue: 34/255, alpha: 1)
            offlineLabel.textColor = .white
            controller.view.addSubview(offlineLabel)
        }
    }
    
    static func hide() {
        offlineLabel.removeFromSuperview()
    }
}
