//
//  NibLoadable.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/13/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol NibLoadable {
    static var nib: UINib { get }
}

extension UITableViewCell: NibLoadable {
    class var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
