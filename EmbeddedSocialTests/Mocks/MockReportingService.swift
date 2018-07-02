//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockReportingService: ReportingServiceType {
    var reportUserCount = 0
    var reportUserInputParameters: (userID: String, reason: ReportReason)?
    var reportUserReturnValue: Result<Void>?
    
    func reportUser(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportUserCount += 1
        reportUserInputParameters = (userID, reason)
        if let result = reportUserReturnValue {
            completion(result)
        }
    }
    
    var reportPostCount = 0
    var reportPostInputParameters: (postID: String, reason: ReportReason)?
    var reportPostReturnValue: Result<Void>?
    
    func reportPost(postID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportPostCount += 1
        reportPostInputParameters = (postID, reason)
        if let result = reportPostReturnValue {
            completion(result)
        }
    }
    
    var reportCommentCount = 0
    var reportCommentInputParameters: (comment: Comment, reason: ReportReason)?
    var reportCommentReturnValue: Result<Void>?
    
    func report(comment: Comment, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportCommentCount += 1
        reportCommentInputParameters = (comment, reason)
        completion(.success())
    }
    
    var reportReplyCount = 0
    var reportReplyInputParameters: (reply: Reply, reason: ReportReason)?
    var reportReplyReturnValue: Result<Void>?
    
    func report(reply: Reply, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportReplyCount += 1
        reportReplyInputParameters = (reply, reason)
        completion(.success())
    }
}
