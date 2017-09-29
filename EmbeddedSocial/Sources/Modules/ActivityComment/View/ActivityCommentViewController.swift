//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol ActivityCommentViewInput: class {
    func setupInitialState()
}

protocol ActivityCommentViewOutput {
    func viewIsReady()
}

class ActivityCommentViewController: UIViewController, ActivityCommentViewInput {

    var output: ActivityCommentViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: ActivityCommentViewInput
    func setupInitialState() {
        
    }
}
