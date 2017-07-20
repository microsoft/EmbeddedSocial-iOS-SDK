//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol SideMenuViewInput: class {

    /**
        @author igor.popov
        Setup initial state of the view
    */

    func setupInitialState()
    func reload()
    func reload(section: Int)
    func showTabBar(visible: Bool)
    func showAccountInfo(visible: Bool)
}
