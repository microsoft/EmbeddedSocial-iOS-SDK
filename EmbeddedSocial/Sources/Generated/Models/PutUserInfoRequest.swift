//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to put (update) user info */
open class PutUserInfoRequest: JSONEncodable {
    /** Gets or sets first name of the user */
    public var firstName: String?
    /** Gets or sets last name of the user */
    public var lastName: String?
    /** Gets or sets short bio of the user */
    public var bio: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["firstName"] = self.firstName
        nillableDictionary["lastName"] = self.lastName
        nillableDictionary["bio"] = self.bio
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
