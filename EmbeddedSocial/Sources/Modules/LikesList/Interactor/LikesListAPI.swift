//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum LikedObject {
    case post
    case comment
    case reply
    
    var noDataText: String {
        switch self {
        case .post:
            return L10n.LikesList.Post.noDataText
        case .comment:
            return L10n.LikesList.Comment.noDataText
        case .reply:
            return L10n.LikesList.Reply.noDataText
        }
    }
}

final class LikesListAPI: UsersListAPI {
    private let likesService: LikesServiceProtocol
    private let handle: String
    private let type: LikedObject

    init(handle: String, type: LikedObject , likesService: LikesServiceProtocol) {
        self.likesService = likesService
        self.handle = handle
        self.type = type
    }
    
    override func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        switch type {
        case .post:
            likesService.getPostLikes(postHandle: handle, cursor: cursor, limit: limit, completion: completion)
        case .comment:
            likesService.getCommentLikes(commentHandle: handle, cursor: cursor, limit: limit, completion: completion)
        case .reply:
            likesService.getReplyLikes(replyHandle: handle, cursor: cursor, limit: limit, completion: completion)
        }
        
    }
}
