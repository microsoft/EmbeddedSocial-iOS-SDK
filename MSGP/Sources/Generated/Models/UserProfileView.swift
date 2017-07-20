//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** User profile view */
open class UserProfileView: JSONEncodable {
    public enum Visibility: String { 
        case _public = "Public"
        case _private = "Private"
    }
    public enum FollowerStatus: String { 
        case _none = "None"
        case follow = "Follow"
        case pending = "Pending"
        case blocked = "Blocked"
    }
    public enum FollowingStatus: String { 
        case _none = "None"
        case follow = "Follow"
        case pending = "Pending"
        case blocked = "Blocked"
    }
    public enum ProfileStatus: String { 
        case active = "Active"
        case banned = "Banned"
        case mature = "Mature"
        case clean = "Clean"
    }
    /** Gets or sets user handle */
    public var userHandle: String?
    /** Gets or sets first name of the user */
    public var firstName: String?
    /** Gets or sets last name of the user */
    public var lastName: String?
    /** Gets or sets short bio of the user */
    public var bio: String?
    /** Gets or sets photo handle of the user */
    public var photoHandle: String?
    /** Gets or sets photo url of the user */
    public var photoUrl: String?
    /** Gets or sets visibility of the user */
    public var visibility: Visibility?
    /** Gets or sets total topics posted by user */
    public var totalTopics: Int64?
    /** Gets or sets total followers for the user */
    public var totalFollowers: Int64?
    /** Gets or sets total following users */
    public var totalFollowing: Int64?
    /** Gets or sets follower relationship status of the querying user */
    public var followerStatus: FollowerStatus?
    /** Gets or sets following relationship status of the querying user */
    public var followingStatus: FollowingStatus?
    /** Gets or sets user profile status */
    public var profileStatus: ProfileStatus?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["userHandle"] = self.userHandle
        nillableDictionary["firstName"] = self.firstName
        nillableDictionary["lastName"] = self.lastName
        nillableDictionary["bio"] = self.bio
        nillableDictionary["photoHandle"] = self.photoHandle
        nillableDictionary["photoUrl"] = self.photoUrl
        nillableDictionary["visibility"] = self.visibility?.rawValue
        nillableDictionary["totalTopics"] = self.totalTopics?.encodeToJSON()
        nillableDictionary["totalFollowers"] = self.totalFollowers?.encodeToJSON()
        nillableDictionary["totalFollowing"] = self.totalFollowing?.encodeToJSON()
        nillableDictionary["followerStatus"] = self.followerStatus?.rawValue
        nillableDictionary["followingStatus"] = self.followingStatus?.rawValue
        nillableDictionary["profileStatus"] = self.profileStatus?.rawValue
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
