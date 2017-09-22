//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockImageCache: ImageCache {
    //MARK: - store
    
    var storePhotoCalled = false
    var storePhotoReceivedPhoto: Photo?
    
    func store(photo: Photo) {
        storePhotoCalled = true
        storePhotoReceivedPhoto = photo
    }
    
    //MARK: - store
    
    var storePhotoCompletionCalled = false
    var storePhotoCompletionReceivedArguments: (photo: Photo, completion: (() -> Void)?)?
    
    func store(photo: Photo, completion: (() -> Void)?) {
        storePhotoCompletionCalled = true
        storePhotoCompletionReceivedArguments = (photo: photo, completion: completion)
        completion?()
    }
    
    //MARK: - store
    
    var storeImageForCalled = false
    var storeImageForReceivedArguments: (image: UIImage, photo: Photo)?
    
    func store(image: UIImage, for photo: Photo) {
        storeImageForCalled = true
        storeImageForReceivedArguments = (image: image, photo: photo)
    }
    
    //MARK: - store
    
    var storeImageForCompletionCalled = false
    var storeImageForCompletionReceivedArguments: (image: UIImage, photo: Photo, completion: (() -> Void)?)?
    
    func store(image: UIImage, for photo: Photo, completion: (() -> Void)?) {
        storeImageForCompletionCalled = true
        storeImageForCompletionReceivedArguments = (image: image, photo: photo, completion: completion)
        completion?()
    }
    
    //MARK: - image
    
    var imageForCalled = false
    var imageForReceivedPhoto: Photo?
    var imageForReturnValue: UIImage?
    
    func image(for photo: Photo) -> UIImage? {
        imageForCalled = true
        imageForReceivedPhoto = photo
        return imageForReturnValue
    }
    
    //MARK: - key
    
    var keyForCalled = false
    var keyForReceivedPhoto: Photo?
    var keyForReturnValue: String!
    
    func key(for photo: Photo) -> String {
        keyForCalled = true
        keyForReceivedPhoto = photo
        return keyForReturnValue
    }
}
