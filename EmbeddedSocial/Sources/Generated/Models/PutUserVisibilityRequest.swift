//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to put (update) user visibility */
open class PutUserVisibilityRequest: JSONEncodable {
    public enum Visibility: String { 
        case _public = "Public"
        case _private = "Private"
    }
    /** Gets or sets visibility of the user */
    public var visibility: Visibility?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["visibility"] = self.visibility?.rawValue
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
