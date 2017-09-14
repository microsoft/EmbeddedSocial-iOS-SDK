//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct Post {
    public var topicHandle: String!
    public var createdTime: Date?
    
    public var user: User?
    
    public var title: String?
    public var text: String?
    public var imageUrl: String?

    public var deepLink: String?
    
    public var totalLikes: Int = 0
    public var totalComments: Int = 0

    public var liked: Bool = false
    public var pinned: Bool = false
    
    public var userHandle: String? {
        return user?.uid
    }
    
    public var userStatus: FollowStatus {
        get {
            return user?.followerStatus ?? .empty
        }
        set {
            user?.followerStatus = newValue
        }
    }
    
    public var firstName: String? {
        return user?.firstName
    }
    
    public var lastName: String? {
        return user?.lastName
    }
    
    public var photoHandle: String? {
        return user?.photo?.uid
    }
    
    public var photoUrl: String? {
        return user?.photo?.url
    }
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
        post.topicHandle = "topic handle \(seed)"
        post.user = User(uid: "user handle", followerStatus: .empty)
        return post
    }
}

extension Post {
    
    init(data: TopicView) {
        
        if let userCompactView = data.user {
            user = User(compactView: userCompactView)
        }
        
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

// MARK: Feed
struct Feed {
    var feedType: FeedType
    var items: [Post]
    var cursor: String? = nil
}

// MARK: PostsFetchResult
struct FeedFetchResult {
    var posts: [Post] = []
    var error: FeedServiceError?
    var cursor: String?
}

extension FeedFetchResult {
    init(response: FeedResponseTopicView?) {
        posts = response?.data?.map(Post.init) ?? []
        error = nil
        cursor = response?.cursor
    }
    
    init(error: Error) {
        self.error = FeedServiceError.failedToFetch(message: error.localizedDescription)
        posts = []
        cursor = nil
    }
}

extension FeedFetchResult {
    
    static func mock() -> FeedFetchResult {
        var result = FeedFetchResult()
        
        let number = arc4random() % 5 + 1
        
        for index in 0..<number {
            result.posts.append(Post.mock(seed: Int(index)))
        }
        return result
    }
}

