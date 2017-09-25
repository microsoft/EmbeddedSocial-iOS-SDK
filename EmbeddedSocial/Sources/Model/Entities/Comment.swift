//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Comment: Equatable {
    
    var commentHandle: String!
    var topicHandle: String!
    var createdTime: Date?
    
    var userHandle: String?
    var firstName: String?
    var lastName: String?
    var photoHandle: String?
    var photoUrl: String?
    
    var text: String?
    var mediaHandle: String?
    var mediaUrl: String?
    var totalLikes: Int64 = 0
    var totalReplies: Int64 = 0
    var liked = false
    var pinned = false
    var userStatus: FollowStatus = .empty
    
    var user: User? {
        guard let userHandle = userHandle else { return nil }
        return User(uid: userHandle, firstName: firstName, lastName: lastName, photo: Photo(url: photoUrl))
    }
    
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
    
    convenience init(request: PostCommentRequest, photo: Photo?, topicHandle: String) {
        self.init()
        commentHandle = UUID().uuidString
        text = request.text
        mediaHandle = photo?.uid
        mediaUrl = photo?.url
        self.topicHandle = topicHandle
        createdTime = Date()
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
        userHandle = json["userHandle"] as? String
        firstName = json["firstName"] as? String
        lastName = json["lastName"] as? String
        photoHandle = json["photoHandle"] as? String
        photoUrl = json["photoUrl"] as? String
        text = json["text"] as? String
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
            "userHandle": userHandle,
            "firstName": firstName,
            "lastName": lastName,
            "photoHandle": photoHandle,
            "photoUrl": photoUrl,
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
