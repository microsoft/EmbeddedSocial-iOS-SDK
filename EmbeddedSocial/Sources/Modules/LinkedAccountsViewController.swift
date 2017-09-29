//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class LinkedAccountsViewController: UITableViewController {
    
    @IBOutlet fileprivate weak var facebookSwitch: UISwitch!
    @IBOutlet fileprivate weak var googleSwitch: UISwitch!
    @IBOutlet fileprivate weak var microsoftSwitch: UISwitch!
    @IBOutlet fileprivate weak var twitterSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
}
