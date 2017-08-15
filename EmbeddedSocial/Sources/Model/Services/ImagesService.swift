//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

private let imageFileType = "image/jpeg"

protocol ImagesServiceType {
    func uploadContentImage(_ image: UIImage, completion: @escaping (Result<String>) -> Void)
    
    func uploadUserImage(_ image: UIImage, authorization: Authorization, completion: @escaping (Result<String>) -> Void)
    
    func updateUserPhoto(_ photo: Photo, completion: @escaping (Result<Photo>) -> Void)
}

class ImagesService: BaseService, ImagesServiceType {
    
    func uploadContentImage(_ image: UIImage, completion: @escaping (Result<String>) -> Void) {
        uploadImageData(image.compressed(), imageType: .contentBlob, authorization: authorization, completion: completion)
    }
    
    func uploadUserImage(_ image: UIImage, authorization: Authorization, completion: @escaping (Result<String>) -> Void) {
        uploadImageData(image.compressed(), imageType: .userPhoto, authorization: authorization, completion: completion)
    }
    
    private func uploadImageData(_ data: Data?,
                                 imageType: ImagesAPI.ImageType_imagesPostImage,
                                 authorization: Authorization,
                                 completion: @escaping (Result<String>) -> Void) {
        
        guard let data = data else {
            completion(.failure(APIError.custom("Image is invalid")))
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
    
    func updateUserPhoto(_ photo: Photo, completion: @escaping (Result<Photo>) -> Void) {
        guard let image = photo.image else {
            completion(.failure(APIError.custom("Image is missing")))
            return
        }
        
        uploadImageData(image.compressed(), imageType: .userPhoto, authorization: authorization) { [unowned self] result in
            guard let handle = result.value else {
                completion(.failure(result.error ?? APIError.unknown))
                return
            }
            
            let request = PutUserPhotoRequest()
            request.photoHandle = handle
            
            UsersAPI.usersPutUserPhoto(request: request, authorization: self.authorization) { response, error in
                if error == nil {
                    let photo = Photo(uid: handle, url: photo.url, image: image)
                    completion(.success(photo))
                } else {
                    self.errorHandler.handle(error: error, completion: completion)
                }
            }
        }
    }
}
