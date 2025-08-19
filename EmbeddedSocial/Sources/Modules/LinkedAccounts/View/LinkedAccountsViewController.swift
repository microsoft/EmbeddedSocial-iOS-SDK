//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class LinkedAccountsViewController: UITableViewController {
    
    var output: LinkedAccountsViewOutput!
    
    @IBOutlet fileprivate weak var facebookSwitch: UISwitch!
    @IBOutlet fileprivate weak var googleSwitch: UISwitch!
    @IBOutlet fileprivate weak var microsoftSwitch: UISwitch!
    @IBOutlet fileprivate weak var twitterSwitch: UISwitch!
    
    @IBOutlet fileprivate weak var facebookLabel: UILabel!
    @IBOutlet fileprivate weak var googleLabel: UILabel!
    @IBOutlet fileprivate weak var microsoftLabel: UILabel!
    @IBOutlet fileprivate weak var twitterLabel: UILabel!
    
    fileprivate var labels: [UILabel] {
        return [facebookLabel, googleLabel, microsoftLabel, twitterLabel]
    }
    
    fileprivate var switches: [UISwitch] {
        return [facebookSwitch, googleSwitch, microsoftSwitch, twitterSwitch]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apply(theme: theme)
        output.viewIsReady()
    }
    
    @IBAction func onFacebookSwitch(_ sender: UISwitch) {
        output.onFacebookSwitchValueChanged(sender.isOn)
    }
    
    @IBAction func onGoogleSwitch(_ sender: UISwitch) {
        output.onGoogleSwitchValueChanged(sender.isOn)
    }
    
    @IBAction func onMicrosoftSwitch(_ sender: UISwitch) {
        output.onMicrosoftSwitchValueChanged(sender.isOn)
    }
    
    @IBAction func onTwitterSwitch(_ sender: UISwitch) {
        output.onTwitterSwitchValueChanged(sender.isOn)
    }
}

extension LinkedAccountsViewController: LinkedAccountsViewInput {
    
    func setupInitialState() {
        tableView.tableFooterView = UIView()
    }
    
    func setSwitchOn(_ isOn: Bool, for provider: AuthProvider) {
        switcher(for: provider)?.setOn(isOn, animated: true)
    }
    
    func setSwitchEnabled(_ isEnabled: Bool, for provider: AuthProvider) {
        switcher(for: .google)?.isEnabled = isEnabled
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setSwitchesEnabled(_ isEnabled: Bool) {
        for sw in switches {
            sw.isEnabled = isEnabled
        }
    }
    
    private func switcher(for provider: AuthProvider) -> UISwitch? {
        switch provider {
        case .facebook:
            return facebookSwitch
        case .google:
            return googleSwitch
        case .microsoft:
            return microsoftSwitch
        case .twitter:
            return twitterSwitch
        }
    }
}

extension LinkedAccountsViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        view.backgroundColor = palette.contentBackground
        tableView.backgroundColor = palette.contentBackground
        labels.forEach { $0.textColor = palette.textPrimary }
    }
}
