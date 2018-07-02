//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Reply {
    var userHandle: String?
    var userFirstName: String?
    var userLastName: String?
    var userPhotoUrl: String?
    
    var text: String?
    var totalLikes: Int = 0
    var liked = false
    
    var replyHandle: String!
    var commentHandle: String!
    var topicHandle: String?
    var createdTime: Date?
    var lastUpdatedTime: Date?
    var userStatus: FollowStatus = .empty
    
    var user: User? {
        guard let userHandle = userHandle else { return nil }
        return User(uid: userHandle, firstName: userFirstName, lastName: userLastName, photo: Photo(url: userPhotoUrl))
    }
    
    convenience init(replyHandle: String) {
        self.init()
        
        self.replyHandle = replyHandle
    }
    
    convenience init(request: PostReplyRequest) {
        self.init()
        
        replyHandle = UUID().uuidString
        text = request.text
        createdTime = Date()
    }
    
    convenience init(replyView: ReplyView) {
        self.init()
        commentHandle = replyView.commentHandle
        text = replyView.text
        liked = replyView.liked ?? false
        replyHandle = replyView.replyHandle!
        topicHandle = replyView.topicHandle
        createdTime = replyView.createdTime
        lastUpdatedTime = replyView.lastUpdatedTime
        userFirstName = replyView.user?.firstName
        userLastName = replyView.user?.lastName
        userPhotoUrl = replyView.user?.photoUrl
        userHandle = replyView.user?.userHandle
        totalLikes = Int(replyView.totalLikes!)
        userStatus = FollowStatus(status: replyView.user?.followerStatus)
    }
}

extension Reply: JSONEncodable {
    
    convenience init?(json: [String: Any]) {
        guard let replyHandle = json["replyHandle"] as? String else {
            return nil
        }
        
        self.init()
        
        self.replyHandle = replyHandle
        userHandle = json["userHandle"] as? String
        userFirstName = json["userFirstName"] as? String
        userLastName = json["userLastName"] as? String
        userPhotoUrl = json["userPhotoUrl"] as? String
        text = json["text"] as? String
        totalLikes = json["totalLikes"] as? Int ?? 0
        liked = json["liked"] as? Bool ?? false
        commentHandle = json["commentHandle"] as? String
        topicHandle = json["topicHandle"] as? String
        createdTime = json["createdTime"] as? Date
        lastUpdatedTime = json["lastUpdatedTime"] as? Date
        
        if let rawStatus = json["userStatus"] as? Int, let status = FollowStatus(rawValue: rawStatus) {
            userStatus = status
        } else {
            userStatus = .empty
        }
    }
    
    func encodeToJSON() -> Any {
        let json: [String: Any?] = [
            "userHandle": userHandle,
            "userFirstName": userFirstName,
            "userLastName": userLastName,
            "userPhotoUrl": userPhotoUrl,
            "text": text,
            "totalLikes": totalLikes,
            "liked": liked,
            "replyHandle": replyHandle,
            "commentHandle": commentHandle,
            "topicHandle": topicHandle,
            "createdTime": createdTime,
            "lastUpdatedTime": lastUpdatedTime,
            "userStatus": userStatus.rawValue
        ]
        return json.flatMap { $0 }
    }
}

extension Reply: Equatable {
    static func ==(lhs: Reply, rhs: Reply) -> Bool {
        return lhs.replyHandle == rhs.replyHandle
    }
}
