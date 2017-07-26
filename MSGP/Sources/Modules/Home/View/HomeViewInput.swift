//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol HomeViewInput: class {

    /**
        @author igor.popov
        Setup initial state of the view
    */

    func setupInitialState()
    
    func setLayout(type: HomeLayoutType)
    func reload()
    func setRefreshing(state: Bool)
}
