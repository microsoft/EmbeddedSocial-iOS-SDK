//
//  OfflineView.swift
//  EmbeddedSocial
//
//  Created by Mac User on 11.10.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

class OfflineView: UILabel {
    
    func show(in controller: UIViewController) {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30)
        self.textAlignment = .center
        self.text = "OFFLINE"
        self.backgroundColor = .green
        controller.view.addSubview(self)
    }
    
    func hide() {
        self.removeFromSuperview()
    }
}
