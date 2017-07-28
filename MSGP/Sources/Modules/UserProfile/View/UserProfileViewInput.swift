//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserProfileViewInput: class {
    func setupInitialState()
    
    func showError(_ error: Error)
    
    func setIsLoading(_ isLoading: Bool)
    
    func setUser(_ user: User)
    
    func setFollowStatus(_ followStatus: FollowStatus)
    
    func setIsProcessingFollowRequest(_ isLoading: Bool)
}
