//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateCommentImageOperationTests: CreateImageOperationTests {
    
    func testThatItUploadsImageAndUpdatesRelatedHandle() {
        // given
        let photo = Photo(image: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        imageCache.imageForReturnValue = photo.image

        let comment = Comment(commentHandle: UUID().uuidString)
        let relatedCommentCommand = CreateCommentCommand(comment: comment)
        cache.firstOutgoing_ofType_predicate_sortDescriptors_ReturnValue = relatedCommentCommand
        
        let command = CreateCommentImageCommand(photo: photo, relatedHandle: comment.commentHandle)
        service.uploadCommentImageCommentHandleCompletionReturnResult = .success(command.photo.uid)
        
        let predicate = NSPredicate(value: true)
        predicateBuilder.createCommentCommandCommentHandleReturnValue = predicate
        
        let sut = CreateCommentImageOperation(command: command, imagesService: service, predicateBuilder: predicateBuilder,
                                              cache: cache, imageCache: imageCache)
        
        // when
        executeOperationAndWait(sut)
        
        // then
        XCTAssertTrue(imageCache.imageForCalled)
        XCTAssertEqual(imageCache.imageForReceivedPhoto, photo)
        
        XCTAssertEqual(relatedCommentCommand.comment.mediaPhoto?.uid, photo.uid)
        
        XCTAssertTrue(service.uploadCommentImageCommentHandleCompletionCalled)
        XCTAssertEqual(service.uploadCommentImageCommentHandleCompletionReceivedArguments?.image, photo.image)
        XCTAssertEqual(service.uploadCommentImageCommentHandleCompletionReceivedArguments?.commentHandle, comment.commentHandle)
        
        XCTAssertTrue(cache.cacheOutgoing_typeID_Called)
        XCTAssertTrue(cache.firstOutgoing_ofType_predicate_sortDescriptors_Called)
        XCTAssertEqual(cache.firstOutgoing_ofType_predicate_sortDescriptors_ReceivedArguments?.predicate, predicate)
        
        XCTAssertTrue(predicateBuilder.createCommentCommandCommentHandleCalled)
        XCTAssertEqual(predicateBuilder.createCommentCommandCommentHandleReceivedCommentHandle, comment.commentHandle)
    }
    
    func testThatItFinishesWithErrorWhenUploadFails() {
        // given
        let error = APIError.unknown
        service.uploadCommentImageCommentHandleCompletionReturnResult = .failure(error)

        let comment = Comment(commentHandle: UUID().uuidString)
        let photo = Photo(image: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        imageCache.imageForReturnValue = photo.image

        let command = CreateCommentImageCommand(photo: photo, relatedHandle: comment.commentHandle)
        let sut = CreateCommentImageOperation(command: command, imagesService: service, predicateBuilder: predicateBuilder,
                                              cache: cache, imageCache: imageCache)
        
        // when
        executeOperationAndWait(sut)
        
        // then
        guard let resultError = sut.error as? APIError, case APIError.unknown = resultError else {
            XCTFail("Must contain error returned from service")
            return
        }
        
        XCTAssertTrue(imageCache.imageForCalled)
        XCTAssertEqual(imageCache.imageForReceivedPhoto, photo)
        
        XCTAssertTrue(service.uploadCommentImageCommentHandleCompletionCalled)
        XCTAssertFalse(cache.cacheOutgoing_typeID_Called)
        XCTAssertFalse(cache.firstOutgoing_ofType_predicate_sortDescriptors_Called)
    }
    
    func testThatItFinishesWhenImageIsMissingFromCache() {
        // given
        imageCache.imageForReturnValue = nil
        
        let command = CreateCommentImageCommand(photo: Photo(), relatedHandle: UUID().uuidString)
        let sut = CreateCommentImageOperation(command: command, imagesService: service, predicateBuilder: predicateBuilder,
                                              cache: cache, imageCache: imageCache)
        
        // when
        executeOperationAndWait(sut)
        
        // then
        XCTAssertTrue(imageCache.imageForCalled)
        XCTAssertFalse(service.uploadCommentImageCommentHandleCompletionCalled)
        XCTAssertFalse(cache.cacheOutgoing_typeID_Called)
        XCTAssertFalse(cache.firstOutgoing_ofType_predicate_sortDescriptors_Called)
    }
}
