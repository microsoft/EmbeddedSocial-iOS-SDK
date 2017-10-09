//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol TabMenuContainerViewOutput {

    /**
        @author igor.popov
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func didSelect(tab: TabMenuContainerTabs)
}
