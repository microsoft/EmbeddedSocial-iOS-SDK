//
//  SideMenuSideMenuViewController.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, SideMenuViewInput, SideMenuSectionHeaderDelegate {
    
    var output: SideMenuViewOutput!
    
    @IBOutlet var tabbarShownConstraint: NSLayoutConstraint?
    @IBOutlet var accountInfoShownConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var accountInfoView: SideMenuAccountInfoView?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    // MARK: SideMenuViewInput
    func setupInitialState() {
        accountInfoView?.configure(with: SideMenuHeaderModel(accountName: "Sting", accountImage: UIImage(asset: .iconTwitter)))
    
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
    
    // MARK: UX
    @IBAction func onTapBar(_ sender: UIButton) {
        output.didSwitch(to: sender.tag)
    }
    
    func showTabBar(visible: Bool) {
        tabbarShownConstraint!.isActive = visible
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func showAccountInfo(visible: Bool) {
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

