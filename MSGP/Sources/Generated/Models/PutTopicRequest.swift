//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to put (update) topic */
open class PutTopicRequest: JSONEncodable {
    /** Gets or sets topic title */
    public var title: String?
    /** Gets or sets topic text */
    public var text: String?
    /** Gets or sets topic categories */
    public var categories: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["title"] = self.title
        nillableDictionary["text"] = self.text
        nillableDictionary["categories"] = self.categories
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
