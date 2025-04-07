//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Comment: Equatable {
    
    var commentHandle: String!
    var topicHandle: String!
    var createdTime: Date?

    var user: User?
    
    
    var text: String?
    var mediaHandle: String?
    var mediaUrl: String?
    var totalLikes: Int64 = 0
    var totalReplies: Int64 = 0
    var liked = false
    var pinned = false
    var userStatus: FollowStatus = .empty
    
    var mediaPhoto: Photo? {
        guard let mediaHandle = mediaHandle else { return nil }
        return Photo(uid: mediaHandle, url: mediaUrl)
    }
    
    static func ==(left: Comment, right: Comment) -> Bool{
        return left.commentHandle == right.commentHandle
    }
}

extension Comment {
    convenience init(commentHandle: String) {
        self.init()
        self.commentHandle = commentHandle
    }
    
    convenience init(text: String, photo: Photo?, topicHandle: String) {
        self.init()
        commentHandle = UUID().uuidString
        self.text = text
        mediaHandle = photo?.uid
        mediaUrl = photo?.url
        self.topicHandle = topicHandle
        createdTime = Date()
    }
    
    convenience init(commentView: CommentView) {
        self.init()
        commentHandle = commentView.commentHandle!
        user = User(compactView: commentView.user!)
        createdTime = commentView.createdTime
        text = commentView.text
        mediaUrl = commentView.blobUrl
        mediaHandle = commentView.blobHandle
        topicHandle = commentView.topicHandle
        totalLikes = commentView.totalLikes ?? 0
        liked = commentView.liked ?? false
        userStatus = FollowStatus(status: commentView.user?.followerStatus)
        totalReplies = commentView.totalReplies ?? 0
    }
}

extension Comment: JSONEncodable {
    
    convenience init?(json: [String: Any]) {
        guard let commentHandle = json["commentHandle"] as? String else {
            return nil
        }
        
        self.init()
        
        self.commentHandle = commentHandle
        self.topicHandle = json["topicHandle"] as? String
        createdTime = json["createdTime"] as? Date
        text = json["text"] as? String
        if let userJSON = json["user"] as? [String: Any] {
            user = User(memento: userJSON)
        }
        mediaUrl = json["mediaUrl"] as? String
        mediaHandle = json["mediaHandle"] as? String
        totalLikes = json["totalLikes"] as? Int64 ?? 0
        totalReplies = json["totalReplies"] as? Int64 ?? 0
        liked = json["liked"] as? Bool ?? false
        pinned = json["pinned"] as? Bool ?? false
        
        if let rawUserStatus = json["userStatus"] as? Int,
            let status = FollowStatus(rawValue: rawUserStatus) {
            userStatus = status
        } else {
            userStatus = .empty
        }
    }
    
    func encodeToJSON() -> Any {
        let json: [String: Any?] = [
            "commentHandle": commentHandle,
            "topicHandle": topicHandle,
            "createdTime": createdTime,
            "user": user?.encodeToJSON(),
            "text": text,
            "mediaUrl": mediaUrl,
            "mediaHandle": mediaHandle,
            "totalLikes": totalLikes,
            "totalReplies": totalReplies,
            "liked": liked,
            "pinned": pinned,
            "userStatus": userStatus.rawValue
        ]
        return json.flatMap { $0 }
    }
}
