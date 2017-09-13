//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol ActivityViewInput: class {
    func setupInitialState()
}

protocol ActivityViewOutput {
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func viewModel(for indexPath: IndexPath) -> ActivityItemViewModel
    
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
        tableView.register(FollowRequestCell.self, forCellReuseIdentifier: FollowRequestCell.reuseID)
    }

    // MARK: ActivityViewInput
    func setupInitialState() {
        
        tableView.reloadData()
    }

}

protocol ActivityItemViewModel {
    var identifier: String { get }
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return output.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = output.viewModel(for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.identifier, for: indexPath) as? ActivityViewModelConfigurable else {
            fatalError("Cell mismatch")
        }
        
        cell.configure(with: viewModel)
        
        return cell as! UITableViewCell
    }
    
}
