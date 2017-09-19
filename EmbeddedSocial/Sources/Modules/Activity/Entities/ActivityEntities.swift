//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ActionItem {
    
    var unread: Bool
    
    enum ActivityType: String {
        case like = "Like"
        case comment = "Comment"
        case reply = "Reply"
        case commentPeer = "CommentPeer"
        case replyPeer = "ReplyPeer"
        case following = "Following"
        case followRequest = "FollowRequest"
        case followAccept = "FollowAccept"
    }
    
    var type: ActivityType
    
    var actorNameList: [(firstName: String, lastName: String)] = []
    var actedOnName: String
}


struct CellRepresentation {
    var identifier: String
    var clazz: AnyObject.Type
}

enum ActivityItem {
    case myActivity
    case othersActivity
    case myPendings
}

extension ActivityItem {
    
    var viewRepresentation: CellRepresentation {
        switch self {
        case .myActivity, .othersActivity, .myPendings:
           return CellRepresentation(identifier: ActivityCell.reuseID, clazz: ActivityCell.self)
        }
    }
}

struct PendingRequestItem {
    var userName: String
    var userHandle: String
}

enum ItemType {
    case myActivity
    case othersActivity
    case myPendings
}

enum ModuleError: Int, Error {
    case notParsable
    case noData
    case mapperNotFound
    case loaderNotFound
}

class PaggedSection<T> {
    
    var name: String
    var limit: Int = 10
    var items: [T] = [T]()
    var cursor: String?
    let itemType: ItemType
    
    init(itemType: ItemType, name: String) {
        self.name = name
        self.itemType = itemType
    }
    
    var pages: Int {
        return items.count / limit
    }
    
    func pageForItem(_ index: Int) -> Int {
        assert(index >= 0 && index < items.count, "Index out of bounds")
        return index / limit
    }
    
    var nextPageAvailable: Bool {
        return cursor != nil
    }
}


