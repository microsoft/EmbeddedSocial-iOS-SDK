//
//  TableDataDisplayManager.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

protocol TableDataDisplayManager {
    func tableDataSource(for tableView: UITableView) -> UITableViewDataSource?
    
    var tableDelegate: UITableViewDelegate? { get }
    
    func registerCells(for tableView: UITableView)
}

extension TableDataDisplayManager {
    
    func registerCells(for tableView: UITableView) {
        print("TableDataDisplayManager.registerCells(for:) - Optional method.")
    }
}
