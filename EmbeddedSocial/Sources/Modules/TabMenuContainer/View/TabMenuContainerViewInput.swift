//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol TabMenuContainerViewInput: class {

    /**
        @author igor.popov
        Setup initial state of the view
    */
    
    func setupInitialState()
    
    func select(tab: TabMenuContainerTabs)
    func show(tab: UIViewController)
}
