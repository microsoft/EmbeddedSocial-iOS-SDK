//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol KeyValueStorage {
    func set(_ value: Any?, forKey defaultName: String)
    
    func object(forKey defaultName: String) -> Any?
    
    func removeObject(forKey defaultName: String)
    
    func purge(key: String)
    
    func dictionaryRepresentation() -> [String: Any]
}
