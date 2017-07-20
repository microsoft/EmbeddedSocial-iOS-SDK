//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CreateAccountViewInput: class {
    func setupInitialState(with user: SocialUser)
    
    func setUser(_ user: SocialUser)
    
    func showError(_ error: Error)
    
    func setCreateAccountButtonEnabled(_ isEnabled: Bool)
    
    func setIsLoading(_ isLoading: Bool)
}
