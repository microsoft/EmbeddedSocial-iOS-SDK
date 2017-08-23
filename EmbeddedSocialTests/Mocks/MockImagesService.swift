//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockImagesService: ImagesServiceType {
    private(set) var uploadContentImageCount = 0
    private(set) var uploadUserImageCount = 0
    private(set) var updateUserPhotoCount = 0
    private(set) var deleteUserPhotoCount = 0
    
    func uploadContentImage(_ image: UIImage, completion: @escaping (Result<String>) -> Void) {
        uploadContentImageCount += 1
    }
    
    func uploadUserImage(_ image: UIImage, authorization: Authorization, completion: @escaping (Result<String>) -> Void) {
        uploadUserImageCount += 1
    }
    
    func updateUserPhoto(_ photo: Photo, completion: @escaping (Result<Photo>) -> Void) {
        updateUserPhotoCount += 1
    }
    
    func deleteUserPhoto(authorization: Authorization, completion: @escaping (Result<Void>) -> Void) {
        deleteUserPhotoCount += 1
    }
}
