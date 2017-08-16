//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import EmbeddedSocial

final class MockEmbeddedEditProfileView: UIView, EmbeddedEditProfileViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var setUserCount = 0
    private(set) var setIsLoadingCount = 0
    
    private(set) var lastSetupInitialStateUser: User?
    private(set) var lastSetUser: User?
    private(set) var isLoading: Bool?
    
    func setupInitialState(with user: User) {
        setupInitialStateCount += 1
        lastSetupInitialStateUser = user
    }
    
    func setUser(_ user: User) {
        setUserCount += 1
        lastSetUser = user
    }
    
    func setIsLoading(_ isLoading: Bool) {
        setIsLoadingCount += 1
        self.isLoading = isLoading
    }
}
