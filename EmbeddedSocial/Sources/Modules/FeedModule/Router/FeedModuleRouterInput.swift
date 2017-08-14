//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum FeedModuleRoutes {
    
    case postDetails(post: Post)
    case extra
    case openImage(image: String)
    case comments
    case profileDetailes(userHandle: UserHandle)
    
}

protocol FeedModuleRouterInput {
    
    func open(route: FeedModuleRoutes)

}
