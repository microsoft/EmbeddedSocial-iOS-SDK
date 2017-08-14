//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateAccountInteractorTests: XCTestCase {
    var userService: MockUserService!
    var imageCache: MockImageCache!
    var sut: CreateAccountInteractor!
    
    override func setUp() {
        super.setUp()
        userService = MockUserService()
        imageCache = MockImageCache()
        sut = CreateAccountInteractor(userService: userService, imageCache: imageCache)
    }
    
    override func tearDown() {
        super.tearDown()
        userService = nil
        imageCache = nil
        sut = nil
    }
    
    func testThatAccountIsCreated() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
        let user = SocialUser(credentials: credentials, firstName: nil, lastName: nil, email: nil, photo: nil)
            
        // when
        sut.createAccount(for: user) { _ in () }
        
        // then
        XCTAssertEqual(userService.createAccountCount, 1)
    }
    
    func testThatPhotoIsCached() {
        // given
        let photo = Photo()
        
        // when
        sut.cachePhoto(photo)
        
        // then
        XCTAssertEqual(imageCache.storePhotoSyncCount, 1)
    }
    
    func testThatPhotoIsUpdatedWithImageFromCache() {
        // given
        let photo = Photo()
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        imageCache.imageToReturn = image
        
        // when
        let updatedPhoto = sut.updatedPhotoWithImageFromCache(photo)
        
        // then
        XCTAssertEqual(updatedPhoto.image, image)
    }
}
