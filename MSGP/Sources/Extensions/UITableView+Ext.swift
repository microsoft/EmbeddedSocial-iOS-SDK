//
//  UITableView+Ext.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellClass: T.Type = T.self) where T: Reusable {
        let className = String(describing: cellClass.self)
        let bundle = Bundle(for: cellClass.self)
        if bundle.path(forResource: className, ofType: "nib") != nil {
            let nib = UINib(nibName: className, bundle: bundle)
            register(nib, forCellReuseIdentifier: cellClass.reuseID)
        } else {
            register(cellClass.self, forCellReuseIdentifier: cellClass.reuseID)
        }
    }
}
