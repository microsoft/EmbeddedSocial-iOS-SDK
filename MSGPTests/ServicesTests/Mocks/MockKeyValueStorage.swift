//
//  MockKeyValueStorage.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

@testable import MSGP

final class MockKeyValueStorage: KeyValueStorage {
    private(set) var setObjectCount = 0
    
    private(set) var getObjectCount = 0
    
    private(set) var removeObjectCount = 0
    
    private(set) var purgeObjectCount = 0
    
    func set(_ value: Any?, forKey defaultName: String) {
        setObjectCount += 1
    }
    
    func object(forKey defaultName: String) -> Any? {
        getObjectCount += 1
        return nil
    }
    
    func removeObject(forKey defaultName: String) {
        removeObjectCount += 1
    }
    
    func purge(key: String) {
        purgeObjectCount += 1
    }
}
