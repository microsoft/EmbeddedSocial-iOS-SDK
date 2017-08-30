//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PostViewModelActionsProtocol: class {
    func handle(action: PostCellAction, path: IndexPath)
}

struct PostViewModel {
    
    typealias ActionHandler = (PostCellAction, IndexPath) -> Void
    
    var topicHandle: String = ""
    var userName: String = ""
    var title: String = ""
    var text: String = ""
    var isLiked: Bool = false
    var isPinned: Bool = false
    var likedBy: String = ""
    var totalLikes: String = ""
    var totalComments: String = ""
    var timeCreated: String = ""
    var userImageUrl: String? = nil
    var postImageUrl: String? = nil
    
    var tag: Int = 0
    var cellType: String = PostCell.reuseID
    
    // sourcery: skipEquality
    var onAction: ActionHandler?
    
    mutating func config(with post: Post, index: Int? = 0, cellType: String? = PostCell.reuseID, actionHandler: PostViewModelActionsProtocol) {
        let formatter = DateFormatterTool()
        topicHandle = post.topicHandle
        userName = User.fullName(firstName: post.firstName, lastName: post.lastName)
        title = post.title ?? ""
        text = post.text ?? ""
        likedBy = "" // TODO: uncomfirmed
        
        totalLikes = L10n.Post.likesCount(post.totalLikes)
        totalComments = L10n.Post.commentsCount(post.totalComments)
        
        timeCreated =  post.createdTime == nil ? "" : formatter.shortStyle.string(from: post.createdTime!, to: Date())!
        userImageUrl = post.photoUrl
        postImageUrl = post.imageUrl
        
        isLiked = post.liked
        isPinned = post.pinned
        
        tag = index ?? 0
        self.cellType = cellType ?? PostCell.reuseID
        onAction = { action, path in
            actionHandler.handle(action: action, path: path)
        }
        
    }
    
}
