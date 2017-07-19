//
//  CreateAccountCreateAccountRouterInput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol CreateAccountRouterInput {
    func openImagePicker(from vc: UIViewController, completion: @escaping (Result<UIImage>) -> Void)
}
