//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SearchHistoryStorage {
    private let ud: UserDefaults
    private let userID: String
    
    var scope: String?
    
    private var storageKey: String {
        return "SearchHistoryRepository-\(scope ?? "")-\(userID)"
    }
    
    init(userDefaults: UserDefaults = UserDefaults.standard, userID: String) {
        ud = userDefaults
        self.userID = userID
    }
    
    func save(_ searchRequest: String) {
        var requests = ud.value(forKey: storageKey) as? [String] ?? []
        if let idx = requests.index(of: searchRequest) {
            requests.remove(at: idx)
        }
        requests.insert(searchRequest, at: 0)
        ud.set(requests, forKey: storageKey)
    }
    
    func searchRequests() -> [String] {
        return ud.value(forKey: storageKey) as? [String] ?? []
    }
}
