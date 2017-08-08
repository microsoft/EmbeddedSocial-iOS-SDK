//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct User {
    let uid: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let bio: String?
    let photo: Photo?
    let credentials: CredentialsList?
    var followersCount: Int
    var followingCount: Int
    let visibility: Visibility?
    var followerStatus: FollowStatus?
    let followingStatus: FollowStatus?
    
    var fullName: String {
        if firstName == nil {
            return lastName ?? Constants.Placeholder.unknown
        }
        
        if lastName == nil {
            return firstName ?? Constants.Placeholder.unknown
        }
        
        return "\(firstName!) \(lastName!)"
    }
    
    var isMe: Bool {
        return credentials != nil
    }
    
    init(uid: String,
         firstName: String? = nil,
         lastName: String? = nil,
         email: String? = nil,
         bio: String? = nil,
         photo: Photo? = nil,
         credentials: CredentialsList? = nil,
         followersCount: Int = 0,
         followingCount: Int = 0,
         visibility: Visibility? = nil,
         followerStatus: FollowStatus? = nil,
         followingStatus: FollowStatus? = nil) {
        
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.bio = bio
        self.photo = photo
        self.credentials = credentials
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.visibility = visibility
        self.followerStatus = followerStatus
        self.followingStatus = followingStatus
    }
}

extension User {
    init(socialUser: SocialUser, userHandle: String) {
        uid = userHandle
        firstName = socialUser.firstName
        lastName = socialUser.lastName
        email = socialUser.email
        bio = socialUser.bio
        photo = socialUser.photo
        credentials = socialUser.credentials
        followersCount = 0
        followingCount = 0
        visibility = nil
        followerStatus = nil
        followingStatus = nil
    }
    
    init(profileView: UserProfileView, credentials: CredentialsList? = nil) {
        self.credentials = credentials

        uid = profileView.userHandle!
        firstName = profileView.firstName
        lastName = profileView.lastName
        email = nil
        bio = profileView.bio
        photo = Photo(uid: profileView.photoHandle ?? UUID().uuidString, url: profileView.photoUrl)
        followersCount = Int(profileView.totalFollowers ?? 0)
        followingCount = Int(profileView.totalFollowing ?? 0)
        
        visibility = profileView.visibility != nil ? Visibility(visibility: profileView.visibility!) : ._private
        
        followerStatus = FollowStatus(status: profileView.followerStatus)
        followingStatus = FollowStatus(status: profileView.followingStatus)
    }
    
    init(compactView: UserCompactView) {
        uid = compactView.userHandle!
        firstName = compactView.firstName
        lastName = compactView.lastName
        photo = Photo(uid: compactView.photoHandle ?? UUID().uuidString, url: compactView.photoUrl)
        visibility = compactView.visibility != nil ? Visibility(visibility: compactView.visibility!) : ._private
        followerStatus = FollowStatus(status: compactView.followerStatus)
        
        email = nil
        bio = nil
        followersCount = 0
        followingCount = 0
        followingStatus = nil
        credentials = nil
    }
}
