//
//  Visibility.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/26/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

enum Visibility: Int {
    case _public
    case _private
    
    init(visibility: UserProfileView.Visibility) {
        switch visibility {
        case ._public:
            self = ._public
        default:
            self = ._private
        }
    }
}
