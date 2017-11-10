//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateCommentCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        let comment = Comment(commentHandle: UUID().uuidString)
        let sut = CreateCommentCommand(comment: comment)
        XCTAssertNil(sut.inverseCommand)
    }
    
    func testThatItProcessesFeedWithRelatedTopic() {
        let post1 = Post.mock()
        let comment = Comment(commentHandle: "1")
        comment.topicHandle = post1.topicHandle
        let command = CreateCommentCommand(comment: comment)
        
        var feed = FeedFetchResult(query: nil, posts: [post1], error: nil, cursor: nil)
        command.apply(to: &feed)
        
        XCTAssertEqual(feed.posts[0].totalComments, 1)
    }
    
    func testThatItProcessesFeedWithUnrelatedTopic() {
        let post1 = Post.mock()
        let comment = Comment(commentHandle: "1")
        comment.topicHandle = ""
        let command = CreateCommentCommand(comment: comment)
        
        var feed = FeedFetchResult(query: nil, posts: [post1], error: nil, cursor: nil)
        command.apply(to: &feed)
        
        XCTAssertEqual(feed.posts[0].totalComments, 0)
    }
    
    func testThatItProcessesFeedWithMultipleTopics() {
        let post = Post.mock(seed: 1)
        let comment = Comment(commentHandle: "1")
        comment.topicHandle = post.topicHandle
        let command = CreateCommentCommand(comment: comment)
        
        var feed = FeedFetchResult(query: nil, posts: [Post.mock(seed: 2), post, Post.mock(seed: 3)], error: nil, cursor: nil)
        command.apply(to: &feed)
        
        XCTAssertEqual(feed.posts[0].totalComments, 0)
        XCTAssertEqual(feed.posts[1].totalComments, 1)
        XCTAssertEqual(feed.posts[2].totalComments, 0)
    }
}
