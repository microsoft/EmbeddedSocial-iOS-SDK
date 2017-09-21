//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateTopicImageOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        let topicHandle = UUID().uuidString
        let photo = Photo(image: image)
        let command = CreateTopicImageCommand(photo: photo, relatedHandle: topicHandle)
        
        let service = MockImagesService()
        service.uploadTopicImageTopicHandleCompletionReturnResult = .success(command.photo.uid)
        
        let sut = CreateTopicImageOperation(command: command, imagesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.uploadTopicImageTopicHandleCompletionCalled)
        XCTAssertEqual(service.uploadTopicImageTopicHandleCompletionReceivedArguments?.image, image)
        XCTAssertEqual(service.uploadTopicImageTopicHandleCompletionReceivedArguments?.topicHandle, topicHandle)
    }
}
