//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

private let imageFileType = "image/jpeg"

protocol ImagesServiceType {
    func uploadTopicImage(_ image: UIImage, topicHandle: String, completion: @escaping (Result<String>) -> Void)
    
    func uploadCommentImage(_ image: UIImage, commentHandle: String, completion: @escaping (Result<String>) -> Void)
    
    func uploadUserImage(_ image: UIImage, authorization: Authorization, completion: @escaping (Result<String>) -> Void)
    
    func updateUserPhoto(_ photo: Photo, completion: @escaping (Result<Photo>) -> Void)
    
    func deleteUserPhoto(authorization: Authorization, completion: @escaping (Result<Void>) -> Void)
}

class ImagesService: BaseService, ImagesServiceType {
    
    private let imageCache: ImageCache
    
    init(imageCache: ImageCache = ImageCacheAdapter.shared) {
        self.imageCache = imageCache
        super.init()
    }
    
    func uploadTopicImage(_ image: UIImage, topicHandle: String, completion: @escaping (Result<String>) -> Void) {
        let photo = Photo(image: image)
        let command = CreateTopicImageCommand(photo: photo, relatedHandle: topicHandle)
        execute(command: command, imageType: .contentBlob, completion: completion)
    }
    
    func uploadCommentImage(_ image: UIImage, commentHandle: String, completion: @escaping (Result<String>) -> Void) {
        let photo = Photo(image: image)
        let command = CreateCommentImageCommand(photo: photo, relatedHandle: commentHandle)
        execute(command: command, imageType: .contentBlob, completion: completion)
    }
    
    private func execute(command: ImageCommand,
                         imageType: ImagesAPI.ImageType_imagesPostImage,
                         completion: @escaping (Result<String>) -> Void) {
        
        cacheCommand(command)
        completion(.success(command.photo.uid))

        uploadImageData(command.photo.image?.compressed(), imageType: imageType) { result in
            if let handle = result.value {
                let photo = Photo(uid: handle, image: command.photo.image)
                self.imageCache.store(photo: photo)
                self.deleteCommand(command)
            } else if self.errorHandler.canHandle(result.error) {
                self.errorHandler.handle(result.error)
            }
        }
    }
    
    private func cacheCommand(_ command: ImageCommand) {
        cache.cacheOutgoing(command)
        imageCache.store(photo: command.photo)
    }
    
    private func deleteCommand(_ command: ImageCommand) {
        cache.deleteOutgoing(with: PredicateBuilder().predicate(for: command))
        imageCache.remove(photo: command.photo)
    }
    
    func uploadUserImage(_ image: UIImage, authorization: Authorization, completion: @escaping (Result<String>) -> Void) {
        uploadImageData(image.compressed(), imageType: .userPhoto, authorization: authorization) { [weak self] result in
            if let handle = result.value {
                completion(.success(handle))
            } else {
                self?.errorHandler.handle(error: result.error, completion: completion)
            }
        }
    }
    
    func updateUserPhoto(_ photo: Photo, completion: @escaping (Result<Photo>) -> Void) {
        uploadImageData(photo.image?.compressed(), imageType: .userPhoto, authorization: authorization) { result in
            guard let handle = result.value else {
                completion(.failure(result.error ?? APIError.unknown))
                return
            }
            
            let request = PutUserPhotoRequest()
            request.photoHandle = handle
            
            UsersAPI.usersPutUserPhoto(request: request, authorization: self.authorization) { response, error in
                if error == nil {
                    var photo = photo
                    photo.uid = handle
                    completion(.success(photo))
                } else {
                    self.errorHandler.handle(error: error, completion: completion)
                }
            }
        }
    }
    
    private func uploadImageData(_ data: Data?,
                                 imageType: ImagesAPI.ImageType_imagesPostImage,
                                 completion: @escaping (Result<String>) -> Void) {
        uploadImageData(data, imageType: imageType, authorization: authorization, completion: completion)
    }
    
    private func uploadImageData(_ data: Data?,
                                 imageType: ImagesAPI.ImageType_imagesPostImage,
                                 authorization: Authorization,
                                 completion: @escaping (Result<String>) -> Void) {
        
        guard let data = data else {
            completion(.failure(APIError.invalidImage))
            return
        }
        
        ImagesAPI.imagesPostImage(
            imageType: imageType,
            authorization: authorization,
            image: data,
            imageFileType: imageFileType) { [weak self] response, error in
                if let handle = response?.blobHandle {
                    completion(.success(handle))
                } else {
                    self?.errorHandler.handle(error: error, completion: completion)
                }
        }
    }
    
    func deleteUserPhoto(authorization: Authorization, completion: @escaping (Result<Void>) -> Void) {
        let request = PutUserPhotoRequest()
        request.photoHandle = "null"
        
        UsersAPI.usersPutUserPhoto(request: request, authorization: authorization) { response, error in
            if error == nil {
                completion(.success())
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
}
