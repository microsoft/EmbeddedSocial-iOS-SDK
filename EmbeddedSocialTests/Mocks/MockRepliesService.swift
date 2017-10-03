//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockRepliesService: RepliesServiceProtcol {
    
    //MARK: - fetchReplies
    
    var fetchRepliesCalled = false
    var fetchRepliesReceivedArguments: (commentHandle: String, cursor: String?, limit: Int)?
    var fetchRepliesReturnResult: RepliesFetchResult!
    
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int,cachedResult:  @escaping RepliesFetchResultHandler,resultHandler: @escaping RepliesFetchResultHandler) {
        fetchRepliesCalled = true
        fetchRepliesReceivedArguments = (commentHandle: commentHandle, cursor: cursor, limit: limit)
        resultHandler(fetchRepliesReturnResult)
    }
    
    //MARK: - postReply
    
    var postReplyCalled = false
    var postReplyReceivedReply: Reply?
    var postReplyReturnResponse: PostReplyResponse!

    func postReply(reply: Reply, success: @escaping PostReplyResultHandler, failure: @escaping Failure) {
        postReplyCalled = true
        postReplyReceivedReply = reply
        success(postReplyReturnResponse)
    }
    
    //MARK: - reply
    
    var getReplyCalled = false
    var getReplyReceivedReplyHandle: String?
    var getReplyReturnReply: Reply!
    
    func reply(replyHandle: String, cachedResult: @escaping ReplyHandler , success: @escaping ReplyHandler, failure: @escaping Failure) {
        getReplyCalled = true
        getReplyReceivedReplyHandle = replyHandle
        success(getReplyReturnReply)
    }
    
    //MARK: - delete
    
    var deleteReplyCalled = false
    var deleteReplyReceivedReplyHandle: String?
    var deleteReplyReturnResult: Result<Void>!
    
    func delete(reply: Reply, completion: @escaping ((Result<Void>) -> Void)) {
        deleteReplyCalled = true
        deleteReplyReceivedReplyHandle = reply.replyHandle
        completion(.success())
    }
    
    
}
