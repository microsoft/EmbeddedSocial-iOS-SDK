//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct Post {
    
    enum UserStatus: Int {
        case none
        case follow
        case pending
        case blocked
    }

    public var topicHandle: String!
    public var createdTime: Date?
    
    public var userHandle: String?
    public var userStatus: UserStatus = .none
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
        
        var text = "Post text"
        for i in 0...seed {
            text += "\n \(i)"
        }
        post.text = text
        
        post.liked = seed % 2 == 0
        post.pinned = false
        post.totalLikes = seed
        post.totalComments = seed + 10
        post.topicHandle = "topic handle \(seed)"
        post.userHandle = "user handle"
        post.userStatus = Post.UserStatus.none
        return post
    }
}

extension Post {
    
    init(data: TopicView) {
        
        if let user = data.user {
            firstName = user.firstName
            lastName = user.lastName
            photoUrl = user.photoUrl
            userHandle = user.userHandle
            
            switch user.followerStatus! {
            case ._none:
                userStatus = .none
            case .blocked:
                userStatus = .blocked
            case .follow:
                userStatus = .follow
            case .pending:
                userStatus = .pending
            }
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
    var fetchID: String
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

