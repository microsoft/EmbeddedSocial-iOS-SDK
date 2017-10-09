//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

@testable import EmbeddedSocial

final class MockFollowersView: FollowersViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var showErrorCount = 0
    private(set) var error: Error?
    private(set) var userListView: UIView?
    
    func setupInitialState(userListView: UIView) {
        setupInitialStateCount += 1
        self.userListView = userListView
    }
    
    func showError(_ error: Error) {
        showErrorCount += 1
        self.error = error
    }
}
