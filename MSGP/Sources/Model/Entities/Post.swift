//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct Post {

    public var topicHandle: String?
    public var createdTime: Date?
    public var lastUpdatedTime: Date?
    
    
    public var userHandle: String?
    public var firstName: String?
    public var lastName: String?
    public var photoHandle: String?
    public var photoUrl: String?
    

    public var title: String?
    public var text: String?
    public var imageUrl: String?

    public var deepLink: String?
    
    public var totalLikes: Int64?
    public var totalComments: Int64?

    public var liked: Bool!
    public var pinned: Bool!

}

extension Post {
    
    static func mock(seed: Int) -> Post {
        var post = Post()
        post.title = "Title \(seed)"
        post.text = "\n\(seed)\nL\n\no\nn\ng\nt\ne\nx\nt"
        post.liked = seed % 2 == 0
        post.pinned = false
        post.totalLikes = Int64(seed)
        post.totalComments = Int64(seed) + 10
        return post
    }
    
}
