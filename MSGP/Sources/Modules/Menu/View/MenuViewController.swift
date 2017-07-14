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
    var menuItems: [MenuItemModel] = []
    @IBOutlet weak var tableView: UITableView?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    // MARK: MenuViewInput
    func setupInitialState() {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
    }
    
    func showMenu(with items: [MenuItemModel]) {
        self.menuItems = items
        self.tableView?.reloadData()
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MenuCellView {
            
            cell.configure(withModel: self.menuItems[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.output.openItem(path: indexPath, item: self.menuItems[indexPath.row])
    }
    
}
