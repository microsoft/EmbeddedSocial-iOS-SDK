//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockImagesService: ImagesServiceType {
    //MARK: - uploadTopicImage
    
    var uploadTopicImageTopicHandleCompletionCalled = false
    var uploadTopicImageTopicHandleCompletionReceivedArguments: (image: UIImage, topicHandle: String)?
    var uploadTopicImageTopicHandleCompletionReturnResult: Result<String>!
    
    func uploadTopicImage(_ image: UIImage, topicHandle: String, completion: @escaping (Result<String>) -> Void) {
        uploadTopicImageTopicHandleCompletionCalled = true
        uploadTopicImageTopicHandleCompletionReceivedArguments = (image: image, topicHandle: topicHandle)
        completion(uploadTopicImageTopicHandleCompletionReturnResult)
    }
    
    //MARK: - uploadCommentImage
    
    var uploadCommentImageCommentHandleCompletionCalled = false
    var uploadCommentImageCommentHandleCompletionReceivedArguments: (image: UIImage, commentHandle: String)?
    var uploadCommentImageCommentHandleCompletionReturnResult: Result<String>!
    
    func uploadCommentImage(_ image: UIImage, commentHandle: String, completion: @escaping (Result<String>) -> Void) {
        uploadCommentImageCommentHandleCompletionCalled = true
        uploadCommentImageCommentHandleCompletionReceivedArguments = (image: image, commentHandle: commentHandle)
        completion(uploadCommentImageCommentHandleCompletionReturnResult)
    }
    
    //MARK: - uploadUserImage
    
    var uploadUserImageAuthorizationCompletionCalled = false
    var uploadUserImageAuthorizationCompletionReceivedArguments: (image: UIImage, authorization: Authorization)?
    var uploadUserImageAuthorizationCompletionReturnResult: Result<String>!
    
    func uploadUserImage(_ image: UIImage, authorization: Authorization, completion: @escaping (Result<String>) -> Void) {
        uploadUserImageAuthorizationCompletionCalled = true
        uploadUserImageAuthorizationCompletionReceivedArguments = (image: image, authorization: authorization)
        completion(uploadUserImageAuthorizationCompletionReturnResult)
    }
    
    //MARK: - updateUserPhoto
    
    var updateUserPhotoCompletionCalled = false
    var updateUserPhotoCompletionReceivedPhoto: Photo?
    var updateUserPhotoCompletionReturnResult: Result<Photo>!
    
    func updateUserPhoto(_ photo: Photo, completion: @escaping (Result<Photo>) -> Void) {
        updateUserPhotoCompletionCalled = true
        updateUserPhotoCompletionReceivedPhoto = photo
        completion(updateUserPhotoCompletionReturnResult)
    }
    
    //MARK: - deleteUserPhoto
    
    var deleteUserPhotoAuthorizationCompletionCalled = false
    var deleteUserPhotoAuthorizationCompletionReceivedAuthorization: Authorization?
    var deleteUserPhotoAuthorizationCompletionReturnResult: Result<Void>!
    
    func deleteUserPhoto(authorization: Authorization, completion: @escaping (Result<Void>) -> Void) {
        deleteUserPhotoAuthorizationCompletionCalled = true
        deleteUserPhotoAuthorizationCompletionReceivedAuthorization = authorization
        completion(deleteUserPhotoAuthorizationCompletionReturnResult)
    }
}
