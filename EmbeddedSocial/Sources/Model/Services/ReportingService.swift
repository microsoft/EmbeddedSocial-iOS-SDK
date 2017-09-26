//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ReportingServiceType {
    func reportUser(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
    
    func reportPost(postID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
    
    func report(comment: Comment, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
    
    func reportReply(replyID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
}

final class ReportingService: BaseService, ReportingServiceType {
    
    func reportUser(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: reason.rawValue)
        
        ReportingAPI.userReportsPostReport(
            userHandle: userID,
            postReportRequest: request,
            authorization: authorization) { response, error in
                self.processResponse(response: response, error: error, completion: completion)
        }
    }
    
    func reportPost(postID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: reason.rawValue)
        
        ReportingAPI.topicReportsPostReport(
            topicHandle: postID,
            postReportRequest: request,
            authorization: authorization) { response, error in
                self.processResponse(response: response, error: error, completion: completion)
        }
    }
    
    func report(comment: Comment, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let command = ReportCommentCommand(comment: comment, reportReason: reason)
        
        guard isNetworkReachable else {
            cache.cacheOutgoing(command)
            completion(.success())
            return
        }
        
        execute(command: command, completion: completion)
    }
    
    func reportReply(replyID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: reason.rawValue)
        
        ReportingAPI.replyReportsPostReport(replyHandle: replyID, postReportRequest: request, authorization: authorization) { (response, error) in
            self.processResponse(response: response, error: error, completion: completion)
        }
    }
    
    private func processResponse(response: Object?, error: ErrorResponse?, completion: @escaping (Result<Void>) -> Void) {
        if error == nil {
            completion(.success())
        } else {
            completion(.failure(APIError(error: error)))
            self.errorHandler.handle(error: error, completion: completion)
        }
    }
    
    private func execute(command: ReportCommentCommand,
                         completion: @escaping (Result<Void>) -> Void) {
        
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: command.reportReason.rawValue)
        
        ReportingAPI.commentReportsPostReport(commentHandle: command.comment.commentHandle, postReportRequest: request, authorization: authorization) { (response, error) in
            if error == nil {
                completion(.success())
            } else {
                completion(.failure(APIError(error: error)))
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
        
    }
}





