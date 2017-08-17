//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class EditProfileInteractorTests: XCTestCase {
    var userService: MockUserService!
    var imageCache: MockImageCache!
    var sut: EditProfileInteractor!
    
    override func setUp() {
        super.setUp()
        userService = MockUserService()
        imageCache = MockImageCache()
        sut = EditProfileInteractor(userService: userService, imageCache: imageCache)
    }
    
    override func tearDown() {
        super.tearDown()
        userService = nil
        imageCache = nil
        sut = nil
    }
    
    func testThatProfileIsEdited() {
        // given
        let user = User()
        
        // when
        sut.editProfile(me: user) { _ in () }
        
        // then
        XCTAssertEqual(userService.updateProfileCount, 1)
    }
    
    func testThatPhotoIsCached() {
        sut.cachePhoto(Photo())
        XCTAssertEqual(imageCache.storePhotoSyncCount, 1)
    }
}
