//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class EditProfileRouter: EditProfileRouterInput {
    func openImagePicker(from vc: UIViewController, completion: @escaping (Result<UIImage>) -> Void) {
        let picker = ImagePicker()
        picker.show(with: ImagePicker.Options(sourceViewController: vc)) { result in
            withExtendedLifetime(picker) {
                completion(result)
            }
        }
    }
}
