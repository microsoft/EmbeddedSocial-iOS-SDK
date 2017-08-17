//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockEmbeddedEditProfileInteractor: EmbeddedEditProfileInteractorInput {    
    private(set) var updatedPhotoWithImageFromCacheCount = 0
    private(set) var updatedPhoto: Photo?
    
    private(set) var cachedPhoto: Photo?
    private(set) var cachePhotoCount = 0
    
    func updatedPhotoWithImageFromCache(_ photo: Photo?) -> Photo {
        updatedPhotoWithImageFromCacheCount += 1
        updatedPhoto = photo
        return photo ?? Photo()
    }
    
    func cachePhoto(_ photo: Photo) {
        cachePhotoCount += 1
        cachedPhoto = photo
    }
}
