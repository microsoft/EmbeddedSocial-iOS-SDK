//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ImageCommandOperation: OutgoingCommandOperation {
    let command: ImageCommand
    let imagesService: ImagesServiceType
    let predicateBuilder: OutgoingCommandsPredicateBuilder
    let cache: CacheType
    let imageCache: ImageCache

    init(command: ImageCommand,
         imagesService: ImagesServiceType,
         predicateBuilder: OutgoingCommandsPredicateBuilder = PredicateBuilder(),
         cache: CacheType = SocialPlus.shared.cache,
         imageCache: ImageCache = ImageCacheAdapter.shared) {
        
        self.command = command
        self.imagesService = imagesService
        self.predicateBuilder = predicateBuilder
        self.cache = cache
        self.imageCache = imageCache
        
        super.init()
    }
}
