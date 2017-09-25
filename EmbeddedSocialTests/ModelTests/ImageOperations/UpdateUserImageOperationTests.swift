//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UpdateUserImageOperationTests: CreateImageOperationTests {
    
    var userHolder: MyProfileHolder!
    
    override func setUp() {
        super.setUp()
        userHolder = MyProfileHolder()
    }
    
    override func tearDown() {
        super.tearDown()
        userHolder = nil
    }
    
    func testThatItUpdatesUserImage() {
        // given
        let photo = Photo(image: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        imageCache.imageForReturnValue = photo.image

        let command = UpdateUserImageCommand(photo: photo, relatedHandle: nil)
        service.updateUserPhotoCompletionReturnResult = .success(command.photo)
        
        let sut = UpdateUserImageOperation(command: command, imagesService: service,
                                           userHolder: userHolder, cache: cache, imageCache: imageCache)
        
        // when
        executeOperationAndWait(sut)
        
        // then
        XCTAssertTrue(imageCache.imageForCalled)
        XCTAssertEqual(imageCache.imageForReceivedPhoto, photo)
        
        XCTAssertTrue(service.updateUserPhotoCompletionCalled)
        XCTAssertEqual(service.updateUserPhotoCompletionReceivedPhoto, photo)
        
        XCTAssertEqual(userHolder.me?.photo, photo)
    }
    
    func testThatItFinishesWithErrorWhenUploadFails() {
        // given
        let photo = Photo(image: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        imageCache.imageForReturnValue = photo.image
        
        let error = APIError.unknown
        service.updateUserPhotoCompletionReturnResult = .failure(error)
        
        let command = UpdateUserImageCommand(photo: photo, relatedHandle: nil)
        let sut = UpdateUserImageOperation(command: command, imagesService: service,
                                           userHolder: userHolder, cache: cache, imageCache: imageCache)
        
        // when
        executeOperationAndWait(sut)
        
        // then
        XCTAssertTrue(imageCache.imageForCalled)
        XCTAssertEqual(imageCache.imageForReceivedPhoto, photo)
        
        XCTAssertTrue(service.updateUserPhotoCompletionCalled)
        XCTAssertEqual(service.updateUserPhotoCompletionReceivedPhoto, photo)
        
        XCTAssertNotEqual(userHolder.me?.photo, photo)
        
        guard let resultError = sut.error as? APIError, case APIError.unknown = resultError else {
            XCTFail("Must contain error returned from service")
            return
        }
    }
}
