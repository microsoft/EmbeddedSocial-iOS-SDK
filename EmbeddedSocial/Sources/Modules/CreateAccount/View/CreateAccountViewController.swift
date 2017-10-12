//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreateAccountViewController: BaseViewController {
    
    var output: CreateAccountViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        output.viewIsReady()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L10n.CreateAccount.Button.signUp,
            style: .plain,
            target: self,
            action: #selector(self.signIn)
        )
    }
    
    @objc private func signIn() {
        output.onCreateAccount()
    }
}

extension CreateAccountViewController: CreateAccountViewInput {
    
    func setupInitialState(with editView: UIView) {
        view.addSubview(editView)
        editView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setCreateAccountButtonEnabled(_ isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}
