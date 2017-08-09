//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestCreatePost: UITestBase {
    var sideMenu: SideMenu!
    var userProfile: UserProfile!
    var createPost: CreatePost!
        
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        userProfile = UserProfile(app)
        createPost = CreatePost(app)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreatePostWithoutImage() {
        sideMenu.navigateToUserProfile()
        
        userProfile.openMenu()
        userProfile.selectMenuOption("Add post")

        createPost.postTitle.tap()
        createPost.postTitle.typeText("Post Title")
        createPost.postText.tap()
        createPost.postText.typeText("Post Text")
        createPost.publish()
        
        let request = APIState.getLatestData(forService: "topics")
        
        XCTAssertEqual(request?["title"] as! String, "Post Title")
        XCTAssertEqual(request?["text"] as! String, "Post Text")
    }
    
}
