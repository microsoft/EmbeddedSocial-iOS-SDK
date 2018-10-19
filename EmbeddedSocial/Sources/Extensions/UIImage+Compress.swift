//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UIImage {
    
    func compressed() -> Data? {
        return jpegData(compressionQuality: Constants.imageCompressionQuality)
    }
}
