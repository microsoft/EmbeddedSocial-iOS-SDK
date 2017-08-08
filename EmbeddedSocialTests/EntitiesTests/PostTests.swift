//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class PostTests: XCTestCase {
    
    var topicViewResponse: FeedResponseTopicView!
    
    override func setUp() {
        super.setUp()
        
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "topics&limit20", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let json = try? JSONSerialization.jsonObject(with: data!)
        
        topicViewResponse = Decoders.decode(clazz: FeedResponseTopicView.self, source: json as AnyObject)
    }
    
    func testPostsAreEqual() {
        
        let a = Post.mock(seed: 100)
        let b = Post.mock(seed: 100)
        
        XCTAssertTrue(a == b)
    }
    
    func testPostsAreNotEqual() {
        
        let a = Post.mock(seed: 100)
        let b = Post.mock(seed: 101)
        
        XCTAssertTrue(a != b)
    }

    func testPost() {
        
        // given
        let postData = topicViewResponse.data!.first!
        
        // when
        let post = Post(data: postData)
        
        // then
        XCTAssertTrue(post.topicHandle == "3uhkWMemLBe")
        XCTAssertTrue(post.userHandle == "3vasrlAHhYf")
        XCTAssertTrue(post.firstName == "Oleg")
        XCTAssertTrue(post.lastName == "Rezhko")
        XCTAssertTrue(post.title == "test 1")
        XCTAssertTrue(post.text == "Test 1")
        
        XCTAssertTrue(post.totalLikes == 2)
        XCTAssertTrue(post.totalComments == 0)
        XCTAssertTrue(post.liked == true)
        XCTAssertTrue(post.pinned == true)
        
        XCTAssertTrue(post.photoHandle == nil)
        XCTAssertTrue(post.imageUrl == nil)
    }
}
