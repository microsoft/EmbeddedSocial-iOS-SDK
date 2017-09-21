//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateCommentImageOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        let commentHandle = UUID().uuidString
        let photo = Photo(image: image)
        let command = CreateCommentImageCommand(photo: photo, relatedHandle: commentHandle)
        
        let service = MockImagesService()
        service.uploadCommentImageCommentHandleCompletionReturnResult = .success(command.photo.uid)
        
        let sut = CreateCommentImageOperation(command: command, imagesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.uploadCommentImageCommentHandleCompletionCalled)
        XCTAssertEqual(service.uploadCommentImageCommentHandleCompletionReceivedArguments?.image, image)
        XCTAssertEqual(service.uploadCommentImageCommentHandleCompletionReceivedArguments?.commentHandle, commentHandle)
    }
}
