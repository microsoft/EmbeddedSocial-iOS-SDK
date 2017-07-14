//
//  UIView+Ext.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeCircular() {
        layer.cornerRadius = bounds.height / 2.0
        layer.masksToBounds = true
    }
}
