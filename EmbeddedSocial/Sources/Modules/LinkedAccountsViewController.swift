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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    @IBAction func onFacebookSwitch(_ sender: UISwitch) {
        
    }
    
    @IBAction func onGoogleSwitch(_ sender: UISwitch) {
        
    }
    
    @IBAction func onMicrosoftSwitch(_ sender: UISwitch) {
        
    }
    
    @IBAction func onTwitterSwitch(_ sender: UISwitch) {
        
    }
}

extension LinkedAccountsViewController: LinkedAccountsViewInput {
    
    func setupInitialState() {
        tableView.tableFooterView = UIView()
    }
    
    func setFacebookSwitchOn(_ isOn: Bool) {
        facebookSwitch.setOn(isOn, animated: true)
    }
    
    func setGoogleSwitchOn(_ isOn: Bool) {
        googleSwitch.setOn(isOn, animated: true)
    }
    
    func setMicrosoftSwitchOn(_ isOn: Bool) {
        microsoftSwitch.setOn(isOn, animated: true)
    }
    
    func setTwitterSwitchOn(_ isOn: Bool) {
        twitterSwitch.setOn(isOn, animated: true)
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
}















