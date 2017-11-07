//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ReportingServiceType {
    func reportUser(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
    
    func reportPost(postID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
    
    func report(comment: Comment, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
    
    func report(reply: Reply, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
}

final class ReportingService: BaseService, ReportingServiceType {
    
    private var executor: AtomicOutgoingCommandsExecutor!
    
    init(provider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        super.init()
        executor = provider.makeAtomicOutgoingCommandsExecutor(for: self)
    }
    
    func reportUser(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: reason.rawValue)
        
        let builder = ReportingAPI.userReportsPostReportWithRequestBuilder(
            userHandle: userID,
            postReportRequest: request,
            authorization: authorization
        )
        
        let command = ReportUserCommand(user: User(uid: userID), reason: reason)
        
        executor.execute(command: command, builder: builder, completion: completion)
    }
    
    func report(comment: Comment, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: reason.rawValue)
        
        let builder = ReportingAPI.commentReportsPostReportWithRequestBuilder(
            commentHandle: comment.commentHandle,
            postReportRequest: request,
            authorization: authorization
        )
        
        let command = ReportCommentCommand(comment: comment, reportReason: reason)

        executor.execute(command: command, builder: builder, completion: completion)
    }
    
    func report(reply: Reply, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: reason.rawValue)
        
        let builder = ReportingAPI.replyReportsPostReportWithRequestBuilder(
            replyHandle: reply.replyHandle,
            postReportRequest: request,
            authorization: authorization
        )
        
        let command = ReportReplyCommand(reply: reply, reportReason: reason)
        
        executor.execute(command: command, builder: builder, completion: completion)
    }
    
    func reportPost(postID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: reason.rawValue)
        
        let builder = ReportingAPI.topicReportsPostReportWithRequestBuilder(
            topicHandle: postID,
            postReportRequest: request,
            authorization: authorization
        )
        
        let command = ReportTopicCommand(topic: Post(topicHandle: postID), reason: reason)
        
        executor.execute(command: command, builder: builder, completion: completion)
    }

}
