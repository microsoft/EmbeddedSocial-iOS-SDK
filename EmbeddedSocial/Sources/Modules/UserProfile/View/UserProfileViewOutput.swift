//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserProfileViewOutput {
    func viewIsReady()
    
    func onEdit()
    
    func onFollowing()
    
    func onFollowRequest(currentStatus followStatus: FollowStatus)
    
    func onFollowers()
    
    func onMore()
}
