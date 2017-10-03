//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PostViewModelActionsProtocol: class {
    func handle(action: FeedPostCellAction, path: IndexPath)
}

struct PostViewModel {
    
    typealias ActionHandler = (FeedPostCellAction, IndexPath) -> Void
    
    let topicHandle: String
    let userName: String
    let title: String
    let text: String
    let isLiked: Bool
    let isPinned: Bool
    let likedBy: String
    let totalLikes: String
    let totalComments: String
    let timeCreated: String
    let userImageUrl: String?
    let postImageUrl: String?
    let postImageHandle: String?
    let isTrimmed: Bool
    let cellType: String
    
    // sourcery: skipEquality
    let onAction: ActionHandler?
  
    init(with post: Post,
         isTrimmed: Bool = false,
         cellType: String,
         actionHandler: ActionHandler? = nil) {
        
        let formatter = DateFormatterTool()
        self.isTrimmed = isTrimmed
        topicHandle = post.topicHandle
        userName = User.fullName(firstName: post.firstName, lastName: post.lastName)
        title = post.title ?? ""
        text = post.text ?? ""
        likedBy = ""
        
        totalLikes = L10n.Post.likesCount(post.totalLikes)
        totalComments = L10n.Post.commentsCount(post.totalComments)
        
        if let createdTime = post.createdTime {
            timeCreated =  formatter.shortStyle.string(from: createdTime, to: Date()) ?? ""
        } else {
            timeCreated = ""
        }
        userImageUrl = post.photoUrl
        postImageUrl = post.imageUrl
        postImageHandle = post.imageHandle
        
        isLiked = post.liked
        isPinned = post.pinned
        
        self.cellType = cellType
        onAction = actionHandler
    }
    
}
