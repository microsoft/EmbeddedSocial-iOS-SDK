//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class UserListView: UIView {
    
    weak var output: UserListViewOutput!
    
    var dataManager: UserListDataDisplayManager!
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.delegate = self.dataManager.tableDelegate
        tableView.dataSource = self.dataManager.tableDataSource(for: tableView)
        self.addSubview(tableView)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UserListView: UserListViewInput {
    
    func setupInitialState() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func setUsers(_ users: [User]) {
        dataManager.setup(tableView: tableView, with: users)
    }
}
