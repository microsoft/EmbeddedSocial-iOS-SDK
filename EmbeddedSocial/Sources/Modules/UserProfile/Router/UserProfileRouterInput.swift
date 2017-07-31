//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserProfileRouterInput {
    func openFollowers(user: User)
    
    func openFollowing(user: User)
    
    func openEditProfile(user: User)
}
