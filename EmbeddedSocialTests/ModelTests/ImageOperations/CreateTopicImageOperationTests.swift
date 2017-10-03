//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateTopicImageOperationTests: CreateImageOperationTests {
    
    func testThatItUploadsImageAndUpdatesRelatedHandle() {
        // given
        let photo = Photo(image: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        imageCache.imageForReturnValue = photo.image
        
        let topic = Post.mock(seed: 0)
        let relatedTopicCommand = CreateTopicCommand(topic: topic)
        cache.firstOutgoing_ofType_predicate_sortDescriptors_ReturnValue = relatedTopicCommand
        
        let predicate = NSPredicate(value: true)
        predicateBuilder.createTopicCommandTopicHandleReturnValue = predicate
        
        let command = CreateTopicImageCommand(photo: photo, relatedHandle: topic.topicHandle)
        service.uploadTopicImageTopicHandleCompletionReturnResult = .success(command.photo.uid)
        
        let sut = CreateTopicImageOperation(command: command, imagesService: service, predicateBuilder: predicateBuilder,
                                            cache: cache, imageCache: imageCache)
        
        // when
        executeOperationAndWait(sut)
        
        // then
        XCTAssertTrue(imageCache.imageForCalled)
        XCTAssertEqual(imageCache.imageForReceivedPhoto, photo)
        
        XCTAssertEqual(relatedTopicCommand.topic.photo?.uid, photo.uid)
        
        XCTAssertTrue(service.uploadTopicImageTopicHandleCompletionCalled)
        XCTAssertEqual(service.uploadTopicImageTopicHandleCompletionReceivedArguments?.image, photo.image)
        XCTAssertEqual(service.uploadTopicImageTopicHandleCompletionReceivedArguments?.topicHandle, topic.topicHandle)
        
        XCTAssertTrue(cache.cacheOutgoing_typeID_Called)
        XCTAssertTrue(cache.firstOutgoing_ofType_predicate_sortDescriptors_Called)
        XCTAssertEqual(cache.firstOutgoing_ofType_predicate_sortDescriptors_ReceivedArguments?.predicate, predicate)
        
        XCTAssertTrue(predicateBuilder.createTopicCommandTopicHandleCalled)
        XCTAssertEqual(predicateBuilder.createTopicCommandTopicHandleReceivedTopicHandle, topic.topicHandle)
    }
    
    func testThatItFinishesWithErrorWhenUploadFails() {
        // given
        let error = APIError.unknown
        service.uploadTopicImageTopicHandleCompletionReturnResult = .failure(error)
        
        let topic = Post.mock(seed: 0)
        let photo = Photo(image: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        imageCache.imageForReturnValue = photo.image
        
        let command = CreateTopicImageCommand(photo: photo, relatedHandle: topic.topicHandle)
        let sut = CreateTopicImageOperation(command: command, imagesService: service, cache: cache, imageCache: imageCache)
        
        // when
        executeOperationAndWait(sut)
        
        // then
        guard let resultError = sut.error as? APIError, case APIError.unknown = resultError else {
            XCTFail("Must contain error returned from service")
            return
        }
        
        XCTAssertTrue(imageCache.imageForCalled)
        XCTAssertEqual(imageCache.imageForReceivedPhoto, photo)
        
        XCTAssertTrue(service.uploadTopicImageTopicHandleCompletionCalled)
        XCTAssertFalse(cache.cacheOutgoing_typeID_Called)
        XCTAssertFalse(cache.firstOutgoing_ofType_predicate_sortDescriptors_Called)
    }
    
    func testThatItFinishesWhenImageIsMissingFromCache() {
        // given
        imageCache.imageForReturnValue = nil
        
        let command = CreateTopicImageCommand(photo: Photo(), relatedHandle: UUID().uuidString)
        let sut = CreateTopicImageOperation(command: command, imagesService: service, cache: cache, imageCache: imageCache)
        
        // when
        executeOperationAndWait(sut)
        
        // then
        XCTAssertTrue(imageCache.imageForCalled)
        XCTAssertFalse(service.uploadTopicImageTopicHandleCompletionCalled)
        XCTAssertFalse(cache.cacheOutgoing_typeID_Called)
        XCTAssertFalse(cache.firstOutgoing_ofType_predicate_sortDescriptors_Called)
    }
}
