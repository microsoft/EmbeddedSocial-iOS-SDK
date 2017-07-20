//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CreateAccountRouterInput {
    func openImagePicker(from vc: UIViewController, completion: @escaping (Result<UIImage>) -> Void)
}
