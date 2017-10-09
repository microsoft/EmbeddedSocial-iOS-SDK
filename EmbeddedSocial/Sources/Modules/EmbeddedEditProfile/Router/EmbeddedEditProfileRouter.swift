//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class EmbeddedEditProfileRouter: EmbeddedEditProfileRouterInput {
    
    fileprivate lazy var picker: ImagePicker = { [unowned self] in
        let picker = ImagePicker()
        picker.delegate = self
        return picker
    }()
    
    var openImageCompletion: ((UIImage?) -> Void)?
    
    func openImagePicker(from vc: UIViewController, isImageSelected: Bool, completion: @escaping (UIImage?) -> Void) {
        openImageCompletion = completion
        picker.imageWasSelected = isImageSelected
        picker.show(with: ImagePicker.Options(sourceViewController: vc))
    }
}

extension EmbeddedEditProfileRouter: ImagePickerDelegate {
    
    func selected(photo: Photo) {
        openImageCompletion?(photo.image)
        openImageCompletion = nil
    }
    
    func removePhoto() {
        openImageCompletion?(nil)
        openImageCompletion = nil
    }
}
