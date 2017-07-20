//
//  MementoSerializable.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

typealias Memento = [String: Any]

protocol MementoSerializable {
    var memento: Memento { get }
    
    init?(memento: Memento)
}
