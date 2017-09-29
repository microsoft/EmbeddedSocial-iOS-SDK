//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    enum ActionSectionItems: Int {
        case blockList
        case signOut
    }
    
    var output: SettingsViewOutput!
    
    @IBOutlet fileprivate weak var privacySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.standardCellHeight
        output.viewIsReady()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case ActionSectionItems.blockList.rawValue:
                output.onBlockedList()
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

