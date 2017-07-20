//
//  KeyValueStorage.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol KeyValueStorage {
    func set(_ value: Any?, forKey defaultName: String)
    
    func object(forKey defaultName: String) -> Any?
    
    func removeObject(forKey defaultName: String)
    
    func purge(key: String)
}
