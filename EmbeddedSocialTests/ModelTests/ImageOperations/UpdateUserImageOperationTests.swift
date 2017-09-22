//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UpdateUserImageOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        let photo = Photo(image: image)
        let command = UpdateUserImageCommand(photo: photo, relatedHandle: nil)
        
        let service = MockImagesService()
        service.updateUserPhotoCompletionReturnResult = .success(command.photo)
        
        let sut = UpdateUserImageOperation(command: command, imagesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.updateUserPhotoCompletionCalled)
        XCTAssertEqual(service.updateUserPhotoCompletionReceivedPhoto, photo)
    }
}
