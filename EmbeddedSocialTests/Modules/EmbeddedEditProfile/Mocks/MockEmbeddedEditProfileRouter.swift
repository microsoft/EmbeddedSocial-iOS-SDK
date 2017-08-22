//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import EmbeddedSocial

final class MockEmbeddedEditProfileRouter: EmbeddedEditProfileRouterInput {
    private(set) var openImagePickerCount = 0
    var imageToReturn: UIImage?
    
    func openImagePicker(from vc: UIViewController, isImageSelected: Bool, completion: @escaping (UIImage?) -> Void) {
        openImagePickerCount += 1
        if let image = imageToReturn {
            completion(image)
        }
    }
}

