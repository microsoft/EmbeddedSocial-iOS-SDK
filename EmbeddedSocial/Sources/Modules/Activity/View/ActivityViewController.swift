//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol ActivityViewInput: class {

        func setupInitialState()
}

protocol ActivityViewOutput {
    
        func viewIsReady()
}

class ActivityViewController: UIViewController, ActivityViewInput {

    var output: ActivityViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: ActivityViewInput
    func setupInitialState() {
    }
}
