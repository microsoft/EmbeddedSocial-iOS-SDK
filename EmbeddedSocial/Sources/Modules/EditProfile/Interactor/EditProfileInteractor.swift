//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

final class EditProfileInteractor: EditProfileInteractorInput {
    private let userService: UserServiceType
    private let imageCache: ImageCache

    init(userService: UserServiceType, imageCache: ImageCache = ImageCacheAdapter.shared) {
        self.userService = userService
        self.imageCache = imageCache
    }
    
    func updatedPhotoWithImageFromCache(_ photo: Photo?) -> Photo {
        guard photo?.image == nil else {
            return photo!
        }
        
        var photo = photo ?? Photo()
        photo.image = imageCache.image(for: photo)
        return photo
    }
    
    func cachePhoto(_ photo: Photo) {
        imageCache.store(photo: photo)
    }
}
