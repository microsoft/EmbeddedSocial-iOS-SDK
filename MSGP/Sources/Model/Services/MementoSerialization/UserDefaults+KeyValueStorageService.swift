//
//  UserDefaults+KeyValueStorage.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension UserDefaults: KeyValueStorage {
    /// User Bundle.main.bundleIdentifier for key to remove whole bundle's storage
    func purge(key: String) {
        UserDefaults.standard.removePersistentDomain(forName: key)
    }
}
