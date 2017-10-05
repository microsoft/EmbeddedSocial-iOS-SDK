//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    enum ActionSectionItems: Int {
        case blockList
        case linkedAccounts
        case signOut
    }
    
    var output: SettingsViewOutput!
    
    @IBOutlet fileprivate weak var privacySwitch: UISwitch!
    @IBOutlet fileprivate weak var privacyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.standardCellHeight
        tableView.tableFooterView = UIView()
        apply(theme: theme)
        output.viewIsReady()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case ActionSectionItems.blockList.rawValue:
                output.onBlockedList()
            case ActionSectionItems.linkedAccounts.rawValue:
                output.onLinkedAccounts()
            case ActionSectionItems.signOut.rawValue:
                output.signOut()
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func onPrivacySwitch(_ sender: UISwitch) {
        output.onPrivacySwitch()
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = theme?.palette.textSecondary
    }
}

extension SettingsViewController: SettingsViewInput {
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setPrivacySwitchEnabled(_ isEnabled: Bool) {
        privacySwitch.isEnabled = isEnabled
    }
    
    func setSwitchIsOn(_ isOn: Bool) {
        privacySwitch.setOn(isOn, animated: false)
    }
}

extension SettingsViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        tableView.backgroundColor = palette.contentBackground
        
        privacyLabel.textColor = palette.textPrimary
        
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section))
                cell?.textLabel?.textColor = palette.textPrimary
                cell?.backgroundColor = palette.tableGroupHeaderBackground
            }
        }
    }
}
