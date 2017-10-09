//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UIImage {
    
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        color.setFill()
        UIRectFill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let cgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: cgImage)
    }
}
