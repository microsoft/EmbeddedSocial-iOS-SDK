//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum FeedModuleRoutes: String {
    
    case postDetails
    case extra
    case comments
}

protocol FeedModuleRouterInput {
    
    func open(route: FeedModuleRoutes)
    func open(post: Post, from view: UIViewController)

}
