//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockImageCache: ImageCache {
    var imageToReturn: UIImage? = UIImage()
    var keyToReturn = UUID().uuidString
    
    var storePhotoSyncCount = 0
    var storePhotoAsyncCount = 0
    var storeImageSyncCount = 0
    var storeImageAsyncCount = 0
    
    func store(photo: Photo) {
        storePhotoSyncCount += 1
    }
    
    func store(photo: Photo, completion: (() -> Void)?) {
        storePhotoAsyncCount += 1
    }
    
    func store(image: UIImage, for photo: Photo) {
        storeImageSyncCount += 1
    }
    
    func store(image: UIImage, for photo: Photo, completion: (() -> Void)?) {
        storeImageAsyncCount += 1
    }
    
    func image(for photo: Photo) -> UIImage? {
        return imageToReturn
    }
    
    func key(for photo: Photo) -> String {
        return keyToReturn
    }
}
