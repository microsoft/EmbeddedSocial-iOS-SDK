//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Content compact view */
open class ContentCompactView: JSONEncodable {
    public enum ContentType: String { 
        case unknown = "Unknown"
        case topic = "Topic"
        case comment = "Comment"
        case reply = "Reply"
    }
    public enum BlobType: String { 
        case unknown = "Unknown"
        case image = "Image"
        case video = "Video"
        case custom = "Custom"
    }
    /** Gets or sets content type */
    public var contentType: ContentType?
    /** Gets or sets content handle */
    public var contentHandle: String?
    /** Gets or sets parent handle */
    public var parentHandle: String?
    /** Gets or sets root handle */
    public var rootHandle: String?
    /** Gets or sets content text */
    public var text: String?
    /** Gets or sets content blob type */
    public var blobType: BlobType?
    /** Gets or sets content blob handle */
    public var blobHandle: String?
    /** Gets or sets content blob url */
    public var blobUrl: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["contentType"] = self.contentType?.rawValue
        nillableDictionary["contentHandle"] = self.contentHandle
        nillableDictionary["parentHandle"] = self.parentHandle
        nillableDictionary["rootHandle"] = self.rootHandle
        nillableDictionary["text"] = self.text
        nillableDictionary["blobType"] = self.blobType?.rawValue
        nillableDictionary["blobHandle"] = self.blobHandle
        nillableDictionary["blobUrl"] = self.blobUrl
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
