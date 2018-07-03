//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ReportViewController: UITableViewController {
    
    var output: ReportViewOutput!
    
    @IBOutlet fileprivate var headerView: UIView!
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    fileprivate lazy var submitButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(title: L10n.Common.submit, style: .plain, target: self, action: #selector(self.onSubmit))
    }()
    
    fileprivate lazy var cancelButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(title: L10n.Common.cancel, style: .plain, target: self, action: #selector(self.onCancel))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        navigationItem.rightBarButtonItem = submitButton
        navigationItem.leftBarButtonItem = cancelButton
        apply(theme: theme)
        output.viewIsReady()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.onRowSelected(at: indexPath)
    }
    
    @objc private func onSubmit() {
        output.onSubmit()
    }
    
    @objc private func onCancel() {
        output.onCancel()
    }
}

extension ReportViewController: ReportViewInput {
    
    func setSubmitButtonEnabled(_ isEnabled: Bool) {
        submitButton.isEnabled = isEnabled
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        if isLoading {
            showHUD()
        } else {
            hideHUD()
        }
    }
    
    func selectCheckmark(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
    }
    
    func deselectCheckmark(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
}

extension ReportViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        
        headerView.backgroundColor = palette.contentBackground
        tableView.backgroundColor = palette.contentBackground
        
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            cell?.textLabel?.textColor = palette.textPrimary
            cell?.backgroundColor = .clear
        }
    }
}










