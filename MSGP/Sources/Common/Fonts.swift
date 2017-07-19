//
//  Fonts.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

struct Fonts {
    static let small = UIFont.systemFont(ofSize: 12.0)
    static let regular = UIFont.systemFont(ofSize: 16.0)
}

// swiftlint:disable type_name
extension Fonts {
    struct bold {
        static let small = UIFont.boldSystemFont(ofSize: 12.0)
        static let regular = UIFont.boldSystemFont(ofSize: 16.0)
    }
}
