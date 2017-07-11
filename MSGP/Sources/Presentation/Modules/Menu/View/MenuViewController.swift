//
//  MenuMenuViewController.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MenuViewInput {

    var output: MenuViewOutput!
    @IBOutlet weak var tableView: UITableView?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: MenuViewInput
    func setupInitialState() {
        self.tableView?.dataSource = self
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MenuCellView {
            
            let vm = self.output.needConfigureCell(path: indexPath)
            cell.configure(vm: vm)
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.output
    }
    
}
