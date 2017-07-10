//
//  Identifiable.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

protocol Identifiable: CustomStringConvertible {
    var identifier: String { get }
}

extension Identifiable {
    var description: String {
        return identifier
    }
}
