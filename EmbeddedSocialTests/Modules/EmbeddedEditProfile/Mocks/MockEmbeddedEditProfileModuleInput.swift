//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockEmbeddedEditProfileModuleInput: EmbeddedEditProfileModuleInput {
    private(set) var isLoading: Bool?
    private(set) var setIsLoadingCount = 0
    
    var finalUser = User()
    private(set) var getFinalUserCount = 0
    
    var moduleView = UIView()
    private(set) var getModuleViewCount = 0
    
    private(set) var setupInitialStateCount = 0

    func setIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
        setIsLoadingCount += 1
    }
    
    func getFinalUser() -> User {
        getFinalUserCount += 1
        return finalUser
    }
    
    func getModuleView() -> UIView {
        getModuleViewCount += 1
        return moduleView
    }
    
    func setupInitialState() {
        setupInitialStateCount += 1
    }
}
