//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Topic view */
open class TopicView: JSONEncodable {
    public enum PublisherType: String { 
        case user = "User"
        case app = "App"
    }
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
    /** Gets or sets topic handle */
    public var topicHandle: String?
    /** Gets or sets created time */
    public var createdTime: Date?
    /** Gets or sets last updated time */
    public var lastUpdatedTime: Date?
    /** Gets or sets publisher type */
    public var publisherType: PublisherType?
    /** Gets or sets owner of the topic */
    public var user: UserCompactView?
    /** Gets or sets topic title */
    public var title: String?
    /** Gets or sets topic text */
    public var text: String?
    /** Gets or sets topic blob type */
    public var blobType: BlobType?
    /** Gets or sets topic blob handle */
    public var blobHandle: String?
    /** Gets or sets topic blob url */
    public var blobUrl: String?
    /** Gets or sets topic categories */
    public var categories: String?
    /** Gets or sets topic language */
    public var language: String?
    /** Gets or sets topic group */
    public var group: String?
    /** Gets or sets topic deep link */
    public var deepLink: String?
    /** Gets or sets topic friendly name */
    public var friendlyName: String?
    /** Gets or sets total likes for the topic */
    public var totalLikes: Int64?
    /** Gets or sets total comments for the topic */
    public var totalComments: Int64?
    /** Gets or sets a value indicating whether the querying user has liked the topic */
    public var liked: Bool?
    /** Gets or sets a value indicating whether the querying user has pinned the topic */
    public var pinned: Bool?
    /** Gets or sets content status */
    public var contentStatus: ContentStatus?
    /** Gets or sets the containing app */
    public var app: AppCompactView?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["topicHandle"] = self.topicHandle
        nillableDictionary["createdTime"] = self.createdTime?.encodeToJSON()
        nillableDictionary["lastUpdatedTime"] = self.lastUpdatedTime?.encodeToJSON()
        nillableDictionary["publisherType"] = self.publisherType?.rawValue
        nillableDictionary["user"] = self.user?.encodeToJSON()
        nillableDictionary["title"] = self.title
        nillableDictionary["text"] = self.text
        nillableDictionary["blobType"] = self.blobType?.rawValue
        nillableDictionary["blobHandle"] = self.blobHandle
        nillableDictionary["blobUrl"] = self.blobUrl
        nillableDictionary["categories"] = self.categories
        nillableDictionary["language"] = self.language
        nillableDictionary["group"] = self.group
        nillableDictionary["deepLink"] = self.deepLink
        nillableDictionary["friendlyName"] = self.friendlyName
        nillableDictionary["totalLikes"] = self.totalLikes?.encodeToJSON()
        nillableDictionary["totalComments"] = self.totalComments?.encodeToJSON()
        nillableDictionary["liked"] = self.liked
        nillableDictionary["pinned"] = self.pinned
        nillableDictionary["contentStatus"] = self.contentStatus?.rawValue
        nillableDictionary["app"] = self.app?.encodeToJSON()
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
