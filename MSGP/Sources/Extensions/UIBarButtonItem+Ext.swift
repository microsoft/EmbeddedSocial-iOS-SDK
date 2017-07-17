//
//  UIBarButtonItem+Ext.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/17/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(asset: Asset? = nil, title: String? = nil, font: UIFont? = nil,
                     color: UIColor, action: (() -> Void)? = nil) {
        let button = UIButton.makeButton(asset: asset, title: title, font: font, color: color, action: action)
        self.init(customView: button)
    }
}
