//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestMyPostMenu: TestOnlineHome {
    
    override func setUp() {
        super.setUp()
        APIConfig.loadMyTopics = true
    }
    
    override func tearDown() {
        super.tearDown()
        APIConfig.loadMyTopics = false
    }
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
    }
    
    func testPostRemoving() {
        openScreen()
        
        let (_, postItem) = feed.getRandomPost()
        let postItemHandle = postItem.getTitle()
        
        XCTAssertTrue(postItem.menu().isExists(item: .remove))
        postItem.menu().select(item: .remove)
        
        XCTAssertEqual(APIState.latestRequstMethod, "DELETE")
        XCTAssertTrue(APIState.getLatestRequest().hasSuffix("/topics/\(postItemHandle)"))
    }
    
    func testPostEditing() {
        openScreen()
        
        let (_, postItem) = feed.getRandomPost()
        let postItemHandle = postItem.getTitle()
        
        XCTAssertTrue(postItem.menu().isExists(item: .edit))
        postItem.menu().select(item: .edit)
        
        let newPostTitle = "New Title"
        let newPostText = "New Text"
        
        let editPostView = EditPost(app)
        editPostView.updatePostWith(title: newPostTitle, text: newPostText)
        editPostView.save()
        
        let postUpdateRequest = APIState.requestHistory[APIState.requestHistory.count - 1]
        XCTAssertTrue(postUpdateRequest.hasSuffix("/topics/\(postItemHandle)"))
        
        let latestRequestData = APIState.getLatestData(forService: "topicUpdate")
        XCTAssertNotNil(latestRequestData)
        XCTAssertEqual(newPostTitle, latestRequestData!["title"] as! String)
        XCTAssertEqual(newPostText, latestRequestData!["text"] as! String)
    }
    
}
