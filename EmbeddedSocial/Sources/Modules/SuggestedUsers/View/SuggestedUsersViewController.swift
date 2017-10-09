//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SuggestedUsersViewController: UIViewController {
    
    var output: SuggestedUsersViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}

extension SuggestedUsersViewController: SuggestedUsersViewInput {
    func setupInitialState(userListView: UIView) {
        view.addSubview(userListView)
        userListView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
}
