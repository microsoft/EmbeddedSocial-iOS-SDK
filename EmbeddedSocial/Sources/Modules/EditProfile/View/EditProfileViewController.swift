//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class EditProfileViewController: BaseViewController {
    
    var output: EditProfileViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        output.viewIsReady()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L10n.EditProfile.Button.save,
            style: .plain,
            target: self,
            action: #selector(self.signIn)
        )
    }
    
    @objc private func signIn() {
        output.onEditProfile()
    }
}

extension EditProfileViewController: EditProfileViewInput {
    
    func setupInitialState(with editView: UIView) {
        view.addSubview(editView)
        editView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error, ignoreNoConnectionErrors: false)
    }
    
    func setSaveButtonEnabled(_ isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    func setBackButtonEnabled(_ isEnabled: Bool) {
        navigationItem.hidesBackButton = !isEnabled
    }
}
