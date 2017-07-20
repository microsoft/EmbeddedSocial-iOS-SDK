//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to post (create) comment */
open class PostCommentRequest: JSONEncodable {
    public enum BlobType: String { 
        case unknown = "Unknown"
        case image = "Image"
        case video = "Video"
        case custom = "Custom"
    }
    /** Gets or sets comment text */
    public var text: String?
    /** Gets or sets comment blob type */
    public var blobType: BlobType?
    /** Gets or sets comment blob handle */
    public var blobHandle: String?
    /** Gets or sets comment language */
    public var language: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["text"] = self.text
        nillableDictionary["blobType"] = self.blobType?.rawValue
        nillableDictionary["blobHandle"] = self.blobHandle
        nillableDictionary["language"] = self.language
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
