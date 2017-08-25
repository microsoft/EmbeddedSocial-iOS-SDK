//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockLoginInteractor: LoginInteractorInput {
    private(set) var loginCount = 0
    private(set) var getMyProfileCount = 0
    private(set) var lastProvider: AuthProvider?
    
    func login(provider: AuthProvider, from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        loginCount += 1
        lastProvider = provider
    }
    
    func getMyProfile(socialUser: SocialUser,
                      from viewController: UIViewController?,
                      handler: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        getMyProfileCount += 1
    }
}
