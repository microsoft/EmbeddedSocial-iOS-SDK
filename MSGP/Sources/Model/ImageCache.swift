//
//  ImageCache.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/13/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

protocol ImageCache {
    /// Store image in a background
    func store(image: UIImage, for photo: Photo)

    /// Store image in a background with completion callback
    func store(image: UIImage, for photo: Photo, completion: (() -> Void)?)
    
    /// Attempt to load image for photo model
    func image(for photo: Photo) -> UIImage?
}

final class ImageCacheAdapter: ImageCache {
    
    static let shared = ImageCacheAdapter()
    
    private init() { }
    
    func store(image: UIImage, for photo: Photo) {
        store(image: image, for: photo, completion: nil)
    }
    
    func store(image: UIImage, for photo: Photo, completion: (() -> Void)?) {
        SDImageCache.shared().store(image, forKey: photo.url ?? photo.uid) { 
            completion?()
        }
    }
    
    func image(for photo: Photo) -> UIImage? {
        return SDImageCache.shared().imageFromCache(forKey: photo.url ?? photo.uid)
    }
}
