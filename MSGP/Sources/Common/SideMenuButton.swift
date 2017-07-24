//
//  SideMenuButton.swift
//  MSGP
//
//  Created by Igor Popov on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

class SideMenuButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = (isSelected) ? UIColor.white.withAlphaComponent(0.4) : UIColor.darkGray
        }
    }
    
}
