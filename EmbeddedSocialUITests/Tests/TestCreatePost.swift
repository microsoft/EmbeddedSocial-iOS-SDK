//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestCreatePost: BaseSideMenuTest {
    
    var userProfile: UserProfile!
    var createPost: CreatePost!
        
    override func setUp() {
        super.setUp()
        
        userProfile = UserProfile(app)
        createPost = CreatePost(app)
    }
    
    override func openScreen() {
        navigate(to: .userProfile)
    }
    
    func testCreatePostWithoutImage() {
        openScreen()
        
        userProfile.openMenu()
        userProfile.selectMenuOption("Add post")
        createPost.publishWith(title: "Post Title", text: "Post Text")
        
        let request = APIState.getLatestData(forService: "topics")
        
        XCTAssertEqual(request?["title"] as! String, "Post Title")
        XCTAssertEqual(request?["text"] as! String, "Post Text")
    }
    
}
