//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol ActivityViewInput: class {
    func setupInitialState()
    func registerCell(cell: UITableViewCell.Type, id: String)
    func showError(_ error: Error)
}

protocol ActivityViewOutput: class {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func viewIsReady()
    func cellIdentifier(for indexPath: IndexPath) -> String
    func configure(_ cell: UITableViewCell, for indexPath: IndexPath)
}

class ActivityViewController: UIViewController {
    
    weak var output: ActivityViewOutput!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        output.viewIsReady()
    }
    
    private func setup() {
        
        // Appearance
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
}

extension ActivityViewController: ActivityViewInput {
    
    func showError(_ error: Error) {
        Logger.log(error, event: .veryImportant)
    }
    
    func setupInitialState() {
        
    }
    
    func registerCell(cell: UITableViewCell.Type, id: String) {
        
    }
    
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return output.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = output.cellIdentifier(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        output.configure(cell, for: indexPath)
        
        return cell
    }
    
}

