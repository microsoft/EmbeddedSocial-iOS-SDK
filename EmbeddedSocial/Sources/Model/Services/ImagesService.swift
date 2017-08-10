//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

private let imageFileType = "image/jpeg"

protocol ImagesServiceType {
    func uploadContentImage(_ image: UIImage, completion: @escaping (Result<String>) -> Void)
    
    func uploadUserImage(_ image: UIImage, authorization: Authorization, completion: @escaping (Result<String>) -> Void)
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
}
