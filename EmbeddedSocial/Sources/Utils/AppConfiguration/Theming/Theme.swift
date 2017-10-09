//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Theme {
    let palette: ThemePalette
    let assets: ThemeAssets
    
    init(palette: ThemePalette, assets: ThemeAssets) {
        self.palette = palette
        self.assets = assets
    }
}
