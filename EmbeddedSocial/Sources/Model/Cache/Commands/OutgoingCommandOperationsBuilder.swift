//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol OutgoingCommandOperationsBuilderType {
    static func operation(for command: OutgoingCommand) -> Operation?
}

struct OutgoingCommandOperationsBuilder: OutgoingCommandOperationsBuilderType {
    
    static func operation(for command: OutgoingCommand) -> Operation? {
        // user commands
        if let command = command as? FollowCommand {
            return FollowOperation(command: command, socialService: SocialService())
        } else if let command = command as? UnfollowCommand {
            return UnfollowOperation(command: command, socialService: SocialService())
        } else if let command = command as? BlockCommand {
            return BlockOperation(command: command, socialService: SocialService())
        } else if let command = command as? UnblockCommand {
            return UnblockOperation(command: command, socialService: SocialService())
        } else if let command = command as? CancelPendingCommand {
            return CancelPendingOperation(command: command, socialService: SocialService())
        }
        
        // topic commands
        else if let command = command as? LikeTopicCommand {
            return LikeTopicOperation(command: command, likesService: LikesService())
        } else if let command = command as? UnlikeTopicCommand {
            return UnlikeTopicOperation(command: command, likesService: LikesService())
        } else if let command = command as? PinTopicCommand {
            return PinTopicOperation(command: command, likesService: LikesService())
        } else if let command = command as? UnpinTopicCommand {
            return UnpinTopicOperation(command: command, likesService: LikesService())
        } else if let command = command as? CreateTopicCommand {
            return CreateTopicOperation(command: command, topicsService: TopicService(imagesService: ImagesService()))
        }
        
        // reply commands
        else if let command = command as? LikeReplyCommand {
            return LikeReplyOperation(command: command, likesService: LikesService())
        } else if let command = command as? UnlikeReplyCommand {
            return UnlikeReplyOperation(command: command, likesService: LikesService())
        } else if let command = command as? CreateReplyCommand {
            return CreateReplyOperation(command: command, repliesService: RepliesService())
        }
        
        // comment commands
        else if let command = command as? LikeCommentCommand {
            return LikeCommentOperation(command: command, likesService: LikesService())
        } else if let command = command as? UnlikeCommentCommand {
            return UnlikeCommentOperation(command: command, likesService: LikesService())
        } else if let command = command as? CreateCommentCommand {
            return CreateCommentOperation(command: command, commentsService: CommentsService(imagesService: ImagesService()))
        }
        
        // image commands
        else if let command = command as? CreateTopicImageCommand {
            return CreateTopicImageOperation(command: command, imagesService: ImagesService())
        } else if let command = command as? CreateCommentImageCommand {
            return CreateCommentImageOperation(command: command, imagesService: ImagesService())
        } else if let command = command as? UpdateUserImageCommand {
            return UpdateUserImageOperation(command: command, imagesService: ImagesService())
        }
        
        return nil
    }
}
