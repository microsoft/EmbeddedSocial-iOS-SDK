//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol SideMenuViewInput: class {
    
    func setupInitialState()
    func reload()
    func reload(section: Int)
    func reload(item: IndexPath)
    func showTabBar(visible: Bool)
    func selectBar(with index: Int)
    func showAccountInfo(visible: Bool)
}

protocol SideMenuViewOutput {
  
    func viewIsReady()
    func didSwitch(to tab: Int)
    func didTapAccountInfo()
    func didSelectItem(with path: IndexPath)
    func didToggleSection(with index: Int)
    
    func itemsCount(in section: Int) -> Int
    func sectionsCount() -> Int
    func section(with index: Int) -> SideMenuSectionModel
    func item(at index: IndexPath) -> SideMenuItemModelProtocol
    func headerTitle(for section: Int) -> String
    func accountInfo() -> SideMenuHeaderModel
    func viewDidAppear()
}


class SideMenuViewController: UIViewController, SideMenuViewInput, SideMenuSectionHeaderDelegate {
    
    var output: SideMenuViewOutput!
    
    @IBOutlet var tabbarShownConstraint: NSLayoutConstraint?
    @IBOutlet var accountInfoShownConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accountInfoView: SideMenuAccountInfoView?
    @IBOutlet weak var socialButton: SideMenuButton?
    @IBOutlet weak var clientButton: SideMenuButton?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    // MARK: SideMenuViewInput
    func setupInitialState() {
        tableView.register(SideMenuSectionHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(SideMenuCellView.self, forCellReuseIdentifier: SideMenuCellView.reuseID)
        tableView.register(SideMenuCellViewWithNotification.self, forCellReuseIdentifier: SideMenuCellViewWithNotification.reuseID)
    }
    
    func reload() {
        tableView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    func reload(section: Int) {
        tableView?.beginUpdates()
        tableView?.reloadSections([section], with: .fade)
        tableView?.endUpdates()
    }
    
    func selectBar(with index: Int) {
        socialButton?.isSelected = socialButton?.tag == index
        clientButton?.isSelected = clientButton?.tag == index
    }
    
    func selectItem(with index: Int) {
        
    }
    
    // MARK: UX
    @IBAction func onTapBar(_ sender: UIButton) {
        output.didSwitch(to: sender.tag)
    }
    
    @IBAction func onAccountInfo(_ sender: UIControl) {
        output.didTapAccountInfo()
    }
    
    func showTabBar(visible: Bool) {
        tabbarShownConstraint!.isActive = visible
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func showAccountInfo(visible: Bool) {
        
        let accountInfoModel = output.accountInfo()
        accountInfoView?.configure(with: accountInfoModel)
        accountInfoShownConstraint?.isActive = visible
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SideMenuSectionHeader else {
            return nil
        }
        
        header.index = section
        header.model = output.section(with: section)
        header.delegate = self
        
        return header
    }
    
    private func dequeCell(for item: SideMenuItemModelProtocol, tableView: UITableView, indexPath: IndexPath) -> SideMenuCellView {
        switch item {
        case is SideMenuItemModelWithNotification:
            let cell: SideMenuCellViewWithNotification = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        default:
            let cell: SideMenuCellView = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = output.item(at: indexPath)
        let cell = dequeCell(for: item, tableView: tableView, indexPath: indexPath)
            
        cell.configure(withModel: item)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return output.sectionsCount()
    }
    
    func reload(item: IndexPath) {
        tableView.reloadRows(at: [item], with: .none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.itemsCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.didSelectItem(with: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // MARK: Section Delegate
    
    func didToggle(section: SideMenuSectionHeader, index: Int) {
        output.didToggleSection(with: index)
    }
}

