//
//  CellModel.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol CellModel: Reusable {
    var cellClass: UITableViewCell.Type { get }
}
