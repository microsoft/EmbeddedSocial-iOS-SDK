//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UpdateUserImageOperation: ImageCommandOperation {
    
    private let userHolder: UserHolder
    
    init(command: ImageCommand,
         imagesService: ImagesServiceType,
         userHolder: UserHolder = SocialPlus.shared,
         cache: CacheType = SocialPlus.shared.cache,
         imageCache: ImageCache = ImageCacheAdapter.shared) {
        
        self.userHolder = userHolder
        super.init(command: command, imagesService: imagesService, cache: cache, imageCache: imageCache)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        var photo = command.photo
        photo.image = imageCache.image(for: command.photo)
        
        imagesService.updateUserPhoto(photo) { [weak self] result in
            guard let strongSelf = self, !strongSelf.isCancelled else {
                return
            }
            
            guard let photo = result.value else {
                strongSelf.completeOperation(with: result.error)
                return
            }
            
            strongSelf.userHolder.me?.photo = photo
            
            strongSelf.completeOperation(with: result.error)
        }
    }
}
