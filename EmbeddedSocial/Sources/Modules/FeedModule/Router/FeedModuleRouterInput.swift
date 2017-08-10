//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum FeedModuleRoutes {
    
    case postDetails
    case extra(post: PostHandle)
    case comments
    case profileDetailes(user: UserHandle)
    
}

protocol FeedModuleRouterInput {
    
    func open(route: FeedModuleRoutes)

}
