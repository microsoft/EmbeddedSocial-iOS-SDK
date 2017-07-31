//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SideMenuViewController: UIViewController, SideMenuViewInput, SideMenuSectionHeaderDelegate {
    
    var output: SideMenuViewOutput!
    
    @IBOutlet var tabbarShownConstraint: NSLayoutConstraint?
    @IBOutlet var accountInfoShownConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableView: UITableView?
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
        tableView?.register(SideMenuSectionHeader.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    func reload() {
        tableView?.reloadData()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SideMenuCellView else {
            return UITableViewCell()
        }
        
        let item = output.item(at: indexPath)
        cell.configure(withModel: item)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return output.sectionsCount()
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

