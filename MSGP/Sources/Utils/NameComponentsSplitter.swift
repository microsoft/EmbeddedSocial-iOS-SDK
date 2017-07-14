//
//  NameComponentsSplitter.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/12/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

struct NameComponentsSplitter {
    
    static func split(fullName: String) -> (String?, String?) {
        guard !fullName.isEmpty else {
            return (nil, nil)
        }
        let components = fullName.components(separatedBy: .whitespacesAndNewlines)
        let lastName = components.last
        let firstName = components.dropLast().joined(separator: " ")
        return (firstName.isEmpty ? nil : firstName, lastName)
    }
}
