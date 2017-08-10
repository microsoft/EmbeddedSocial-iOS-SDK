//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UIImageView {
    
    /// Set the imageView `image` with a `photo` and a placeholder.
    /// If `photo` has image, it's set immediately.
    /// If it has only URL, it's downloaded and cached.
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
        } else {
            image = placeholder
        }
    }
}
