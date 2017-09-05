//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserProfileRouterInput {
    func openFollowers(user: User)
    
    func openFollowing(user: User)
    
    func openEditProfile(user: User)
    
    func openCreatePost(user: User)
    
    func showMyMenu(_ addPostHandler: @escaping () -> Void)
    
    func showUserMenu(_ user: User, blockHandler: @escaping () -> Void, reportHandler: @escaping () -> Void)
    
    func openReport(user: User)
    
    func popTopScreen()
    
    func openLogin()
}
