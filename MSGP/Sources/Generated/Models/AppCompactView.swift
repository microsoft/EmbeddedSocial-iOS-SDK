//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** App compact view */
open class AppCompactView: JSONEncodable {
    public enum PlatformType: String { 
        case windows = "Windows"
        case android = "Android"
        case ios = "IOS"
    }
    /** Gets or sets app name */
    public var name: String?
    /** Gets or sets app icon handle */
    public var iconHandle: String?
    /** Gets or sets app icon url */
    public var iconUrl: String?
    /** Gets or sets platform type */
    public var platformType: PlatformType?
    /** Gets or sets app deep link */
    public var deepLink: String?
    /** Gets or sets app store link */
    public var storeLink: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["name"] = self.name
        nillableDictionary["iconHandle"] = self.iconHandle
        nillableDictionary["iconUrl"] = self.iconUrl
        nillableDictionary["platformType"] = self.platformType?.rawValue
        nillableDictionary["deepLink"] = self.deepLink
        nillableDictionary["storeLink"] = self.storeLink
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
