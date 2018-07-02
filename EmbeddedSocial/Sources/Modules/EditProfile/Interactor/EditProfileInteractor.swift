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
    
    func editProfile(me: User, completion: @escaping (Result<User>) -> Void) {
        userService.updateProfile(me: me, completion: completion)
    }
    
    func cachePhoto(_ photo: Photo) {
        imageCache.store(photo: photo)
    }
}
