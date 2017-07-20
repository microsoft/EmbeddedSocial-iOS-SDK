//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Comment view */
open class CommentView: JSONEncodable {
    public enum BlobType: String { 
        case unknown = "Unknown"
        case image = "Image"
        case video = "Video"
        case custom = "Custom"
    }
    public enum ContentStatus: String { 
        case active = "Active"
        case banned = "Banned"
        case mature = "Mature"
        case clean = "Clean"
    }
    /** Gets or sets comment handle */
    public var commentHandle: String?
    /** Gets or sets parent topic handle */
    public var topicHandle: String?
    /** Gets or sets created time */
    public var createdTime: Date?
    /** Gets or sets last updated time */
    public var lastUpdatedTime: Date?
    /** Gets or sets owner of the comment */
    public var user: UserCompactView?
    /** Gets or sets comment text */
    public var text: String?
    /** Gets or sets comment blob type */
    public var blobType: BlobType?
    /** Gets or sets comment blob handle */
    public var blobHandle: String?
    /** Gets or sets comment blob url */
    public var blobUrl: String?
    /** Gets or sets comment language */
    public var language: String?
    /** Gets or sets total likes for the comment */
    public var totalLikes: Int64?
    /** Gets or sets total replies for the comment */
    public var totalReplies: Int64?
    /** Gets or sets a value indicating whether the querying user has liked the comment */
    public var liked: Bool?
    /** Gets or sets content status */
    public var contentStatus: ContentStatus?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["commentHandle"] = self.commentHandle
        nillableDictionary["topicHandle"] = self.topicHandle
        nillableDictionary["createdTime"] = self.createdTime?.encodeToJSON()
        nillableDictionary["lastUpdatedTime"] = self.lastUpdatedTime?.encodeToJSON()
        nillableDictionary["user"] = self.user?.encodeToJSON()
        nillableDictionary["text"] = self.text
        nillableDictionary["blobType"] = self.blobType?.rawValue
        nillableDictionary["blobHandle"] = self.blobHandle
        nillableDictionary["blobUrl"] = self.blobUrl
        nillableDictionary["language"] = self.language
        nillableDictionary["totalLikes"] = self.totalLikes?.encodeToJSON()
        nillableDictionary["totalReplies"] = self.totalReplies?.encodeToJSON()
        nillableDictionary["liked"] = self.liked
        nillableDictionary["contentStatus"] = self.contentStatus?.rawValue
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
