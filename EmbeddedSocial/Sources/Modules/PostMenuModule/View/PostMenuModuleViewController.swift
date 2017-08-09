//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import UIKit

protocol PostMenuModuleViewInput: class {
    
    func setupInitialState()
    
}

protocol PostMenuModuleViewOutput {
    
    func viewIsReady()
}

class PostMenuModuleViewController: UIViewController, PostMenuModuleViewInput {

    var output: PostMenuModuleViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: PostMenuModuleViewInput
    func setupInitialState() {
    }
}
