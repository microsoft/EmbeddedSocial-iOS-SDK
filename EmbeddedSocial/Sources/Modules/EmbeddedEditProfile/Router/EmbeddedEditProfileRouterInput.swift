//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol EmbeddedEditProfileRouterInput: class {
    func openImagePicker(from vc: UIViewController, isImageSelected: Bool, completion: @escaping (UIImage?) -> Void)
}
