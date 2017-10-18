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
        if self.superview == nil {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30)
            self.textAlignment = .center
            self.text = L10n.Error.noInternetConnection
            self.font = UIFont.systemFont(ofSize: 13)
            self.backgroundColor = UIColor(red: 34/255 , green: 139/255, blue: 34/255, alpha: 1)
            self.textColor = .white
            controller.view.addSubview(self)
        }

    }
    
    func hide() {
        self.removeFromSuperview()
    }
}
