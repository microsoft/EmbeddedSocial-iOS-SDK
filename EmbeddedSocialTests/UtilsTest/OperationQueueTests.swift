//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class OperationQueueTests: XCTestCase {
    
    class DummyAsyncOperation: AsyncOperation {
        private let duration: TimeInterval
        
        init(duration: TimeInterval) {
            self.duration = duration
            super.init()
        }
        
        override func main() {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.completeOperation()
            }
        }
    }
    
    class WaitMockCommentsService: MockCommentsService {
        
        var postCommentDelay: TimeInterval = 1.0
        
        override func postComment(comment: Comment,
                                  photo: Photo?,
                                  resultHandler: @escaping CommentPostResultHandler,
                                  failure: @escaping Failure) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + postCommentDelay) {
                super.postComment(comment: comment, photo: photo, resultHandler: resultHandler, failure: failure)
            }
        }
    }
    
    func testRunningAsyncOperations() {
        let comment = Comment(commentHandle: "1")
        comment.topicHandle = "2"
        
        let service = WaitMockCommentsService()
        service.postCommentReturnComment = comment
        service.postCommentDelay = 0.5
        
        let opsCount = 10
        var ops: [Operation] = []
        
        for _ in 1..<opsCount {
            let op = CreateCommentOperation(command: CommentCommand(comment: comment), commentsService: service)
            ops.append(op)
        }
        
        var completedCount = 0
        
        for op in ops {
            op.completionBlock = {
                completedCount += 1
            }
        }
        
        let q = OperationQueue()
        q.qualityOfService = .background
        q.addOperations(ops, waitUntilFinished: false)
        
        let timeout = TimeInterval(opsCount) * service.postCommentDelay + 0.5
        expect(q.operationCount).toEventually(equal(0), timeout: timeout)
        expect(completedCount).toEventually(equal(opsCount - 1), timeout: timeout)
    }
}
