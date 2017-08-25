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
        post.text = "\n\(seed)\nL\n\no\nn\ng\nt\ne\nx\nt"
        post.liked = seed % 2 == 0
        post.pinned = false
        post.totalLikes = seed
        post.totalComments = seed + 10
        post.topicHandle = "topic handle"
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

extension Post {
    
    func viewModel(handler: @escaping PostViewModel.ActionHandler) -> PostViewModel {
        let formatter = DateFormatterTool()
        var viewModel = PostViewModel()
        viewModel.topicHandle = self.topicHandle
        viewModel.userName = String(format: "%@ %@", (self.firstName ?? ""), (self.lastName ?? ""))
        viewModel.title = self.title ?? ""
        viewModel.text = self.text ?? ""
        viewModel.likedBy = "" // TODO: uncomfirmed
        
        viewModel.totalLikes = L10n.Post.likesCount(self.totalLikes)
        viewModel.totalComments = L10n.Post.commentsCount(self.totalComments)
        
        viewModel.timeCreated =  self.createdTime == nil ? "" : formatter.shortStyle.string(from: self.createdTime!, to: Date())!
        viewModel.userImageUrl = self.photoUrl
        viewModel.postImageUrl = self.imageUrl
        
        viewModel.isLiked = self.liked
        viewModel.isPinned = self.pinned
        
        viewModel.onAction = handler
    
        
        return viewModel
    }
}

// MARK: PostsFeed
struct PostsFeed {
    var items: [Post]
    var cursor: String? = nil
}

// MARK: PostsFetchResult
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

