//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol ActivityViewInput: class {
    func setupInitialState()
}

protocol ActivityViewOutput {
    func viewIsReady()
}

class ActivityViewController: UIViewController, ActivityViewInput {

    var output: ActivityViewOutput!
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        output.viewIsReady()
    }
    
    private func setup() {
        tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.reuseID)
        tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.reuseID)
    }

    // MARK: ActivityViewInput
    func setupInitialState() {
    }
}
