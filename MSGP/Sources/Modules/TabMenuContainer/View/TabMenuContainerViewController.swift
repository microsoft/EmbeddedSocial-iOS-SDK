//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class TabMenuContainerViewController: UIViewController, TabMenuContainerViewInput {
    
    func select(tab: TabMenuContainerTabs) {
        
    }
    
    func show(tab: UIViewController) {
        
    }

    var output: TabMenuContainerViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: TabMenuContainerViewInput
    func setupInitialState() {
        
    }
}
