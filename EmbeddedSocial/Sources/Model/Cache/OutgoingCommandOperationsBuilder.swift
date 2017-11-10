//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol OutgoingCommandOperationsBuilderType {
    func operation(for command: OutgoingCommand) -> OutgoingCommandOperation?
    
    func fetchCommandsOperation(cache: CacheType, predicate: NSPredicate) -> FetchOutgoingCommandsOperation
}

struct OutgoingCommandOperationsBuilder: OutgoingCommandOperationsBuilderType {
    
    func operation(for command: OutgoingCommand) -> OutgoingCommandOperation? {
        // user commands
        if let command = command as? FollowCommand {
            return FollowUserOperation(command: command, socialService: makeSocialService())
        } else if let command = command as? UnfollowCommand {
            return UnfollowUserOperation(command: command, socialService: makeSocialService())
        } else if let command = command as? BlockCommand {
            return BlockUserOperation(command: command, socialService: makeSocialService())
        } else if let command = command as? UnblockCommand {
            return UnblockUserOperation(command: command, socialService: makeSocialService())
        } else if let command = command as? CancelPendingCommand {
            return CancelPendingUserOperation(command: command, socialService: makeSocialService())
        } else if let command = command as? AcceptPendingCommand {
            return AcceptPendingUserOperation(command: command, socialService: makeSocialService())
        } else if let command = command as? ReportUserCommand {
            return ReportUserOperation(command: command, service: ReportingService())
        }
        
        // topic commands
        else if let command = command as? LikeTopicCommand {
            return LikeTopicOperation(command: command, likesService: makeLikesService())
        } else if let command = command as? UnlikeTopicCommand {
            return UnlikeTopicOperation(command: command, likesService: makeLikesService())
        } else if let command = command as? PinTopicCommand {
            return PinTopicOperation(command: command, likesService: makeLikesService())
        } else if let command = command as? UnpinTopicCommand {
            return UnpinTopicOperation(command: command, likesService: makeLikesService())
        } else if let command = command as? CreateTopicCommand {
            return CreateTopicOperation(command: command, topicsService: TopicService(imagesService: ImagesService()))
        } else if let command = command as? RemoveTopicCommand {
            return RemoveTopicOperation(command: command,
                                        topicsService: TopicService(imagesService: ImagesService()),
                                        cleanupStrategy: CacheCleanupStrategyImpl(cache: SocialPlus.shared.cache))
        } else if let command = command as? UpdateTopicCommand {
            return UpdateTopicOperation(command: command, topicsService: TopicService(imagesService: ImagesService()))
        } else if let command = command as? ReportTopicCommand {
            return ReportTopicOperation(command: command, service: ReportingService())
        }
        
        // reply commands
        else if let command = command as? LikeReplyCommand {
            return LikeReplyOperation(command: command, likesService: makeLikesService())
        } else if let command = command as? UnlikeReplyCommand {
            return UnlikeReplyOperation(command: command, likesService: makeLikesService())
        } else if let command = command as? CreateReplyCommand {
            return CreateReplyOperation(command: command, repliesService: RepliesService())
        } else if let command = command as? RemoveReplyCommand {
            return RemoveReplyOperation(command: command,
                                        repliesService: RepliesService(),
                                        cleanupStrategy: CacheCleanupStrategyImpl(cache: SocialPlus.shared.cache))
        } else if let command = command as? ReportReplyCommand {
            return ReportReplyOperation(command: command, reportService: ReportingService())
        }
        
        // comment commands
        else if let command = command as? LikeCommentCommand {
            return LikeCommentOperation(command: command, likesService: makeLikesService())
        } else if let command = command as? UnlikeCommentCommand {
            return UnlikeCommentOperation(command: command, likesService: makeLikesService())
        } else if let command = command as? CreateCommentCommand {
            return CreateCommentOperation(command: command, commentsService: CommentsService(imagesService: ImagesService()))
        } else if let command = command as? RemoveCommentCommand {
            return RemoveCommentOperation(command: command,
                                          commentService: CommentsService(imagesService: ImagesService()),
                                          cleanupStrategy: CacheCleanupStrategyImpl(cache: SocialPlus.shared.cache))
        } else if let command = command as? ReportCommentCommand {
            return ReportCommentOperation(command: command, reportService: ReportingService())
        }
        
        // image commands
        else if let command = command as? CreateTopicImageCommand {
            return CreateTopicImageOperation(command: command, imagesService: ImagesService())
        } else if let command = command as? CreateCommentImageCommand {
            return CreateCommentImageOperation(command: command, imagesService: ImagesService())
        } else if let command = command as? UpdateUserImageCommand {
            return UpdateUserImageOperation(command: command, imagesService: ImagesService())
        }
        
        // notification commands
        else if let command = command as? UpdateNotificationsStatusCommand {
            return UpdateNotificationsStatusOperation(command: command, notificationsService: ActivityNotificationsService())
        }
        
        // update related handle command
        else if let command = command as? UpdateRelatedHandleCommand {
            return UpdateRelatedHandleOperation(command: command)
        }
        
        return nil
    }
    
    private func makeLikesService() -> LikesServiceProtocol {
        return LikesService()
    }
    
    private func makeSocialService() -> SocialServiceType {
        return SocialService()
    }
    
    func fetchCommandsOperation(cache: CacheType, predicate: NSPredicate) -> FetchOutgoingCommandsOperation {
        return FetchOutgoingCommandsOperation(cache: cache, predicate: predicate)
    }
}
