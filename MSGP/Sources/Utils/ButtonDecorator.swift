//
//  ButtonDecorator.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class ButtonDecorator: UIButton {
    
    let decoratedButton: UIButton
    
    required init(decoratedButton: UIButton) {
        self.decoratedButton = decoratedButton
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
