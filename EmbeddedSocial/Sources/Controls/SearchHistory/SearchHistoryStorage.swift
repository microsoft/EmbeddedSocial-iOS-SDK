//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SearchHistoryStorage {
    private let storage: KeyValueStorage
    private let userID: String
    
    var scope: String?
    
    private var storageKey: String {
        return "SearchHistoryRepository-\(scope ?? "")-\(userID)"
    }
    
    init(storage: KeyValueStorage = UserDefaults.standard, userID: String) {
        self.storage = storage
        self.userID = userID
    }
    
    func save(_ searchRequest: String) {
        var requests = storage.object(forKey: storageKey) as? [String] ?? []
        if let idx = requests.index(of: searchRequest) {
            requests.remove(at: idx)
        }
        requests.insert(searchRequest, at: 0)
        storage.set(requests, forKey: storageKey)
    }
    
    func searchRequests() -> [String] {
        return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        //return storage.object(forKey: storageKey) as? [String] ?? []
    }
}
