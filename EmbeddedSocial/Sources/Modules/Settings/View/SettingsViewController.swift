//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    enum SettingsSections: Int {
        case about
        case privacy
        case account
    }
    
    enum AccountActionsSectionItems: Int {
        case blockList
        case deleteSearchHistory
        case linkedAccounts
        case signOut
        case deleteAccount
    }
    
    enum AboutSectionItems: Int {
        case privacyPolicy
        case termsAndConditions
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
        actionsMapping[indexPath.section]?[indexPath.row]?()
    }
    
    typealias ActionsMapping = [Int: () -> Void]

    private var actionsMapping: [Int: ActionsMapping] {
        let aboutActions: ActionsMapping = [
            AboutSectionItems.privacyPolicy.rawValue: output.onPrivacyPolicy,
            AboutSectionItems.termsAndConditions.rawValue: output.onTermsAndConditions
        ]
        
        let accountActions: ActionsMapping = [
            AccountActionsSectionItems.blockList.rawValue: output.onBlockedList,
            AccountActionsSectionItems.deleteSearchHistory.rawValue: deleteSearchHistoryAndShowSuccessAlert,
            AccountActionsSectionItems.linkedAccounts.rawValue: output.onLinkedAccounts,
            AccountActionsSectionItems.signOut.rawValue: output.signOut,
            AccountActionsSectionItems.deleteAccount.rawValue: showDeleteAccountDialogue
        ]
        
        return [
            SettingsSections.about.rawValue: aboutActions,
            SettingsSections.account.rawValue: accountActions
        ]
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
    
    private func showDeleteAccountDialogue() {
        showYesNoAlert(
            title: L10n.Settings.Alert.deleteAccountTitle,
            message: L10n.Settings.Alert.deleteAccountMessage,
            yesTitle: L10n.Common.delete,
            noTitle: L10n.Common.cancel,
            noHandler: { _ in () },
            yesHandler: { [weak self] _ in self?.output.onDeleteAccount() }
        )
    }
    
    private func deleteSearchHistoryAndShowSuccessAlert() {
        output.onDeleteSearchHistory()
        showAlert(message: L10n.Settings.Alert.searchHistoryDeleted, closeTitle: L10n.Common.ok)
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
    
    func setIsLoading(_ isLoading: Bool) {
        if isLoading {
            showHUD(isBlocking: true)
        } else {
            hideHUD()
        }
    }
}

extension SettingsViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        tableView.backgroundColor = palette.topicsFeedBackground
        
        privacyLabel.textColor = palette.textPrimary
        
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section))
                cell?.textLabel?.textColor = palette.textPrimary
                cell?.backgroundColor = palette.contentBackground
            }
        }
    }
}
