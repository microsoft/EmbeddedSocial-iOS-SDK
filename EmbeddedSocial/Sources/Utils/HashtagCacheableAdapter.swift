//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class HashtagCacheableAdapter {
    fileprivate(set) var handle: String
    fileprivate(set) var hashtag: Hashtag
    
    init(handle: String, hashtag: Hashtag) {
        self.handle = handle
        self.hashtag = hashtag
    }
}

extension HashtagCacheableAdapter: Cacheable {
    
    convenience init?(json: [String: Any]) {
        guard let handle = json["handle"] as? String,
            let hashtag = json["hashtag"] as? Hashtag else {
                return nil
        }
        self.init(handle: handle, hashtag: hashtag)
    }
    
    func encodeToJSON() -> Any {
        return [
            "handle": handle,
            "hashtag": hashtag
        ]
    }
    
    func getHandle() -> String? {
        return handle
    }
    
    func setHandle(_ handle: String?) {
        if let handle = handle {
            self.handle = handle
        }
    }
}
