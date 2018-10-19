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
    let totalLikesShort: String
    let totalComments: String
    let totalCommentsShort: String
    let timeCreated: String
    let userImageUrl: String?
    let postImageUrl: String?
    let postImageHandle: String?
    let isTrimmed: Bool
    let cellType: String
    
    // sourcery: skipEquality
    let onAction: ActionHandler?
    
    var postPhoto: Photo? {
        return postImageHandle != nil ? Photo(uid: postImageHandle!, url: postImageUrl) : nil
    }
  
    init(with post: Post,
         isTrimmed: Bool = false,
         cellType: String,
         actionHandler: ActionHandler? = nil) {
        
        let formatter = DateFormatterTool.shared
        self.isTrimmed = isTrimmed
        topicHandle = post.topicHandle
        userName = User.fullName(firstName: post.firstName, lastName: post.lastName)
        title = post.title ?? ""
        
        likedBy = ""
        
        //
        // To avoid hang on calculating very long texts - we trancute it.
        //
        let limit = 5000
        if let postText = post.text {
            if postText.count > limit {
            text = String(postText.prefix(limit))
            } else {
                text = postText
            }
        } else {
            text = ""
        }
        
        totalLikes = L10n.Post.likesCount(post.totalLikes)
        totalComments = L10n.Post.commentsCount(post.totalComments)
        totalLikesShort = "\(post.totalLikes)"
        totalCommentsShort = "\(post.totalComments)"
        
        if let createdTime = post.createdTime {
            timeCreated =  formatter.timeAgo(since: createdTime) ?? ""
        } else {
            timeCreated = ""
        }
        userImageUrl = post.photoUrl
      
        if let imageUrl = post.imageUrl {
            postImageUrl = imageUrl + Constants.ImageResize.pixels500
        } else {
            postImageUrl = nil
        }
        
        postImageHandle = post.imageHandle
        
        isLiked = post.liked
        isPinned = post.pinned
        
        self.cellType = cellType
        onAction = actionHandler
    }
    
}
