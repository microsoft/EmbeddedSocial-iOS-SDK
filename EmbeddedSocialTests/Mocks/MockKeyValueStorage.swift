//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockKeyValueStorage: KeyValueStorage {
    
    //MARK: - set
    
    var setForKeyCalled = false
    var setForKeyReceivedArguments: (value: Any?, defaultName: String)?
    
    func set(_ value: Any?, forKey defaultName: String) {
        setForKeyCalled = true
        setForKeyReceivedArguments = (value: value, defaultName: defaultName)
    }
    
    //MARK: - object
    
    var objectForKeyCalled = false
    var objectForKeyReceivedDefaultName: String?
    var objectForKeyReturnValue: Any?!
    
    func object(forKey defaultName: String) -> Any? {
        objectForKeyCalled = true
        objectForKeyReceivedDefaultName = defaultName
        return objectForKeyReturnValue
    }
    
    //MARK: - removeObject
    
    var removeObjectForKeyCalled = false
    var removeObjectForKeyReceivedDefaultName: String?
    
    func removeObject(forKey defaultName: String) {
        removeObjectForKeyCalled = true
        removeObjectForKeyReceivedDefaultName = defaultName
    }
    
    //MARK: - purge
    
    var purgeKeyCalled = false
    var purgeKeyReceivedKey: String?
    
    func purge(key: String) {
        purgeKeyCalled = true
        purgeKeyReceivedKey = key
    }
    
    //MARK: - dictionaryRepresentation
    
    var dictionaryRepresentationCalled = false
    var dictionaryRepresentationReturnValue: [String: Any]!
    
    func dictionaryRepresentation() -> [String: Any] {
        dictionaryRepresentationCalled = true
        return dictionaryRepresentationReturnValue
    }

}
