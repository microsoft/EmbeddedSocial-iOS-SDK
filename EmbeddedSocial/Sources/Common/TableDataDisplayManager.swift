//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
