//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol FollowRequestsViewInput: class {
    func setupInitialState()
    
    func setUsers(_ users: [User])
    
    func setIsLoading(_ isLoading: Bool, item: FollowRequestItem)
    
    func setIsLoading(_ isLoading: Bool)
    
    func removeUser(_ user: User)
    
    func endPullToRefreshAnimation()
    
    func setIsEmpty(_ isEmpty: Bool)
    
    func showError(_ error: Error)
    
    func setNoDataText(_ text: NSAttributedString?)
}
