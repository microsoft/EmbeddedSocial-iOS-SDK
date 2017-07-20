//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to post (create) reply */
open class PostReplyRequest: JSONEncodable {
    /** Gets or sets reply text */
    public var text: String?
    /** Gets or sets reply language */
    public var language: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["text"] = self.text
        nillableDictionary["language"] = self.language
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
