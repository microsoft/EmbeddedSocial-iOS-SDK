//
//  CreateAccountValidator.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/17/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

struct CreateAccountValidator: Validator {
    struct Options {
        let firstName: String?
        let lastName: String?
        let bio: String?
        let photo: UIImage?
    }
    
    static func validate(_ value: Options) -> Bool {
        guard let firstName = value.firstName,
            let lastName = value.lastName else {
                return false
        }
        
        return !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
