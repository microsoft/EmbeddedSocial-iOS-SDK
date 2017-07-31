//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias PostHandle = String

enum Feed {
    
    enum PopularType {
        case today, weekly, alltime
    }
    
    // Show home feed
    case home
    // Shows recent feed
    case recent
    // Shows popular feed
    case popular(type: PopularType)
    // Shows single post
    case single(post: PostHandle)
}

protocol HomeModuleInput: class {
    
    var configuration: Feed! { set get }
    
//    var needsShowRecentPosts { set get }
//    var needsShowPopularPosts { set get }
    
    
    
}
