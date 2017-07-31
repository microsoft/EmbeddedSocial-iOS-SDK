//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to post (create) session */
open class PostSessionRequest: JSONEncodable {
    /** Gets or sets instance id -- Unique installation id of the app */
    public var instanceId: String?
    /** Gets or sets user handle */
    public var userHandle: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["instanceId"] = self.instanceId
        nillableDictionary["userHandle"] = self.userHandle
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
