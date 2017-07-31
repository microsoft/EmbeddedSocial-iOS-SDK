//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

final class MockCreateAccountRouter: CreateAccountRouterInput {
    private(set) var openImagePickerCount = 0
    private(set) var lastReturnedImage: UIImage?
    
    func openImagePicker(from vc: UIViewController, completion: @escaping (Result<UIImage>) -> Void) {
        openImagePickerCount += 1
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        lastReturnedImage = image
        completion(.success(image))
    }
}
