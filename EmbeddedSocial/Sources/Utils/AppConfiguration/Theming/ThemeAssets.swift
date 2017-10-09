//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ThemeAssets {
    let iconList: Asset
    let iconGallery: Asset
    let iconDots: Asset
    let userPhotoPlaceholder: Asset
}

extension ThemeAssets {
    
    static let light = ThemeAssets(
        iconList: .iconListLight,
        iconGallery: .iconGalleryLight,
        iconDots: .iconDotsLight,
        userPhotoPlaceholder: .userPhotoPlaceholderLight
    )
    
    static let dark = ThemeAssets(
        iconList: .iconListDark,
        iconGallery: .iconGalleryDark,
        iconDots: .iconDotsDark,
        userPhotoPlaceholder: .userPhotoPlaceholderDark
    )
    
}
