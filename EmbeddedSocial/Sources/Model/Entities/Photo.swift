//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct Photo {
    var uid: String
    let url: String?
    var image: UIImage?
    
    init(uid: String = UUID().uuidString, url: String? = nil, image: UIImage? = nil) {
        self.uid = uid
        self.url = url
        self.image = image
    }
}
