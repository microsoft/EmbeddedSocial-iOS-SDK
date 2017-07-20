//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Post topic name request */
open class PostTopicNameRequest: JSONEncodable {
    public enum PublisherType: String { 
        case user = "User"
        case app = "App"
    }
    /** Gets or sets publisher type */
    public var publisherType: PublisherType?
    /** Gets or sets topic name */
    public var topicName: String?
    /** Gets or sets topic handle */
    public var topicHandle: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["publisherType"] = self.publisherType?.rawValue
        nillableDictionary["topicName"] = self.topicName
        nillableDictionary["topicHandle"] = self.topicHandle
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
