//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum FeedModuleRoutes {
    
    case postDetails(post: Post)
    case myPost(post: Post)
    case othersPost(post: Post)
    case openImage(image: String)
    case comments(post: Post)
    case profileDetailes(user: UserHandle)
    
}


protocol FeedModuleRouterInput {
    
    func open(route: FeedModuleRoutes, feedSource:FeedType)

}
