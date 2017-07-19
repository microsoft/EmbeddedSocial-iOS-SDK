//
//  CreateAccountCreateAccountRouter.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

class CreateAccountRouter: CreateAccountRouterInput {
    
    func openImagePicker(from vc: UIViewController, completion: @escaping (Result<UIImage>) -> Void) {
        let picker = ImagePicker()
        picker.show(with: ImagePicker.Options(sourceViewController: vc)) { result in
            completion(result)
            _ = picker
        }
    }
}
