//
//  UIImageView+ImageCache.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/14/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setPhotoWithCaching(_ photo: Photo?, placeholder: UIImage?) {
        guard let photo = photo else {
            image = placeholder
            return
        }
        
        if let image = photo.image {
            self.image = image
        } else if let cachedImage = ImageCacheAdapter.shared.image(for: photo) {
            image = cachedImage
        } else if let url = photo.url {
            sd_setImage(with: URL(string: url), placeholderImage: placeholder)
        }
    }
}
