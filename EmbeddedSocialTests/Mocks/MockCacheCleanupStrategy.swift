//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCacheCleanupStrategy: CacheCleanupStrategy {
    
    //MARK: - cleanupRelatedCommands
    
    var cleanupRelatedCommandsWithTopicCommandCalled = false
    var cleanupRelatedCommandsWithTopicCommandReceivedCommand: TopicCommand?
    
    func cleanupRelatedCommands(_ command: TopicCommand) {
        cleanupRelatedCommandsWithTopicCommandCalled = true
        cleanupRelatedCommandsWithTopicCommandReceivedCommand = command
    }
    
    //MARK: - cleanupRelatedCommands
    
    var cleanupRelatedCommandsWithCommentCommandCalled = false
    var cleanupRelatedCommandsWithCommentCommandReceivedCommand: CommentCommand?
    
    func cleanupRelatedCommands(_ command: CommentCommand) {
        cleanupRelatedCommandsWithCommentCommandCalled = true
        cleanupRelatedCommandsWithCommentCommandReceivedCommand = command
    }
    
    //MARK: - cleanupRelatedCommands
    
    var cleanupRelatedCommandsWithReplyCommandCalled = false
    var cleanupRelatedCommandsWithReplyCommandReceivedCommand: ReplyCommand?
    
    func cleanupRelatedCommands(_ command: ReplyCommand) {
        cleanupRelatedCommandsWithReplyCommandCalled = true
        cleanupRelatedCommandsWithReplyCommandReceivedCommand = command
    }
    
}
