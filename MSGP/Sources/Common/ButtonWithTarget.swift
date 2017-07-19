//
//  ButtonWithTarget.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/17/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

final class ButtonWithTarget: UIButton {
    
    var onPrimaryActionTriggered: (() -> Void)? {
        didSet {
            if #available(iOS 9.0, *) {
                addTarget(self, action: #selector(tapped(_:)), for: .primaryActionTriggered)
            } else {
                addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func tapped(_ sender: AnyObject) {
        onPrimaryActionTriggered?()
    }
}
