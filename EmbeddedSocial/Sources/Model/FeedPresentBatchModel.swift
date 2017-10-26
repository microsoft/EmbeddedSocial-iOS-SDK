//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import BMACollectionBatchUpdates

class BatchCollection: NSObject, BMAUpdatableCollectionSection {
    
    var items: [BMAUpdatableCollectionItem]
    var uid: String
    
    init(uid: NSString, items: [BMAUpdatableCollectionItem]) {
        self.items = items
        self.uid = uid as String
    }
    
    override var description: String {
        return "\(uid) \(items)"
    }
}

class BatchCollectionItem: NSObject, BMAUpdatableCollectionItem {
    var uid: String {
        return post.topicHandle
    }
    let post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? BatchCollectionItem else {
            return false
        }
        
        return self.post == object.post
    }
    
    override var hash: Int {
        return post.hashValue
    }
    
    override var description: String {
        return "\(uid)"
    }
    
}
