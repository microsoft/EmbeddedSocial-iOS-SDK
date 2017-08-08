//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserListModuleInput: UserListModuleInput {
    let listView = UIView()
    
    var setupInitialStateCount = 0
    
    func setupInitialState() {
        setupInitialStateCount += 1
    }
}
