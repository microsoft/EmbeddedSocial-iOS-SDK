//
//  String+Memento.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension String: MementoSerializable {
    var memento: Memento {
        return ["self": self]
    }
    
    init?(memento: Memento) {
        if let string = memento["self"] as? String {
            self = string
        } else {
            return nil
        }
    }
}
