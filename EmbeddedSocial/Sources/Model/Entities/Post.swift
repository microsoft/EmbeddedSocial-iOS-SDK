//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol AutoEquatable {}

struct Post {

    public var topicHandle: String!
    public var createdTime: Date?
    
    public var userHandle: String?
    public var firstName: String?
    public var lastName: String?
    public var photoHandle: String?
    public var photoUrl: String?
    
    public var title: String?
    public var text: String?
    public var imageUrl: String?

    public var deepLink: String?
    
    public var totalLikes: Int = 0
    public var totalComments: Int = 0

    public var liked: Bool = false
    public var pinned: Bool = false
}

extension Post {
    
    static func mock(seed: Int) -> Post {
        var post = Post()
        post.title = "Title \(seed)"
        post.text = "\n\(seed)\nL\n\no\nn\ng\nt\ne\nx\nt"
        post.liked = seed % 2 == 0
        post.pinned = false
        post.totalLikes = seed
        post.totalComments = seed + 10
        return post
    }
}

extension Post {
    
    init(data: TopicView) {
        firstName = data.user?.firstName
        lastName = data.user?.lastName
        photoUrl = data.user?.photoUrl
        userHandle = data.user?.userHandle
        
        createdTime = data.createdTime
        imageUrl = data.blobUrl
        title = data.title
        text = data.text
        pinned = data.pinned ?? false
        liked = data.liked ?? false
        topicHandle = data.topicHandle
        totalLikes = Int(exactly: Double(data.totalLikes ?? 0))!
        totalComments = Int(exactly: Double(data.totalComments ?? 0))!
    }
    
}


extension Post: AutoEquatable {}

// MARK: PostsFeed

struct PostsFeed {
    var items: [Post]
    var cursor: String? = nil
}

// MARK: PostsFetchResult
//
struct PostFetchResult {
    var posts: [Post] = [Post]()
    var error: FeedServiceError?
    var cursor: String? = nil
}

extension PostFetchResult {
    
    static func mock() -> PostFetchResult {
        var result = PostFetchResult()
        
        let number = arc4random() % 5 + 1
        
        for index in 0..<number {
            result.posts.append(Post.mock(seed: Int(index)))
        }
        return result
    }
}

