//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import SDWebImage
import UIKit

protocol ImageCache {
    /// Store image synchronously
    func store(image: UIImage, for photo: Photo)

    /// Store image asynchronously with completion callback
    func store(image: UIImage, for photo: Photo, completion: (() -> Void)?)
    
    /// Attempt to load image for photo model
    func image(for photo: Photo) -> UIImage?
    
    func key(for photo: Photo) -> String
}

final class ImageCacheAdapter: ImageCache {
    
    static let shared = ImageCacheAdapter()
    
    private init() { }
    
    func store(image: UIImage, for photo: Photo) {
        SDImageCache.shared().storeImageData(toDisk: image.sd_imageData(), forKey: key(for: photo))
    }
    
    func store(image: UIImage, for photo: Photo, completion: (() -> Void)?) {
        SDImageCache.shared().store(image, forKey: key(for: photo)) {
            completion?()
        }
    }
    
    func image(for photo: Photo) -> UIImage? {
        return SDImageCache.shared().imageFromCache(forKey: photo.url ?? photo.uid)
    }
    
    func key(for photo: Photo) -> String {
        return photo.url ?? photo.uid
    }
}
