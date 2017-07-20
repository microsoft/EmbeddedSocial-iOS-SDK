//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to post (create) user */
open class PostUserRequest: JSONEncodable {
    /** Gets or sets instance id -- Unique installation id of the app */
    public var instanceId: String?
    /** Gets or sets first name of the user */
    public var firstName: String?
    /** Gets or sets last name of the user */
    public var lastName: String?
    /** Gets or sets short bio of the user */
    public var bio: String?
    /** Gets or sets photo handle of the user */
    public var photoHandle: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["instanceId"] = self.instanceId
        nillableDictionary["firstName"] = self.firstName
        nillableDictionary["lastName"] = self.lastName
        nillableDictionary["bio"] = self.bio
        nillableDictionary["photoHandle"] = self.photoHandle
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
