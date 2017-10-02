//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct Post {
    var topicHandle: String
    var createdTime: Date?
    
    var user: User
    var imageUrl: String?
    var imageHandle: String?
    
    var title: String?
    var text: String?

    var deepLink: String?
    
    var totalLikes: Int = 0
    var totalComments: Int = 0

    var liked: Bool = false
    var pinned: Bool = false
    
    var userHandle: String {
        return user.uid
    }
    
    var userStatus: FollowStatus {
        get {
            return user.followerStatus ?? .empty
        }
        set {
            user.followerStatus = newValue
        }
    }
    
    var firstName: String? {
        return user.firstName
    }
    
    var lastName: String? {
        return user.lastName
    }
    
    var photoHandle: String? {
        return user.photo?.uid
    }
    
    var photoUrl: String? {
        return user.photo?.url
    }
    
    var photo: Photo? {
        guard let imageHandle = imageHandle else {
            return nil
        }
        return Photo(uid: imageHandle, url: imageUrl)
    }
}

extension Post {
    
    static func mock(seed: Int) -> Post {
        
        let handle = "Handle\(seed)"
        let title = "Title \(seed)"
        var text = "Post text"
        for i in 0...seed {
            text += "\n \(i)"
        }
        
        let liked = seed % 2 == 0
        let pinned = false
        let totalLikes = seed
        let totalComments = seed + 10
        let user = User(uid: "user handle \(seed)", followerStatus: .empty)

        return Post(topicHandle: handle,
                    createdTime: Date(),
                    user: user,
                    imageUrl: nil,
                    imageHandle: nil,
                    title: title,
                    text: text,
                    deepLink: nil,
                    totalLikes: totalLikes,
                    totalComments: totalComments,
                    liked: liked,
                    pinned: pinned)
    }
}

extension Post: JSONEncodable {
    
     init?(json: [String: Any]) {
        
        guard let topicView: TopicView = Decoders.decode(type: TopicView.self, payload: json) else {
            return nil
        }
        
        self.init(data: topicView)
        
//
//        guard let handle = json["topicHandle"] as? String else {
//            return nil
//        }
//
//        createdTime = json["createdTime"] as? Date
//        guard let userJSON = json["user"] as? [String: Any] else {
//            return nil
//        }
//
//        guard let user = User(memento: userJSON) else {
//            return nil
//        }
//
//        guard let title = json["title"] as? String,
//            let text = json["text"] as? String,
//            let imageUrl = json["imageUrl"] as? String,
//            let imageHandle = json["imageHandle"] as? String,
//            let deepLink = json["deepLink"] as? String,
//            let totalLikes = json["totalLikes"] as? Int,
//            let totalComments = json["totalComments"] as? Int,
//            let liked = json["liked"] as? Bool,
//            let pinned = json["pinned"] as? Bool else {
//                return nil
//        }
//
//        self.init(topicHandle: handle,
//                    createdTime: createdTime,
//                    user: user,
//                    imageUrl: imageUrl,
//                    imageHandle: imageHandle,
//                    title: title,
//                    text: text,
//                    deepLink: deepLink,
//                    totalLikes: totalLikes,
//                    totalComments: totalComments,
//                    liked: liked,
//                    pinned: pinned)
    }
    
    func encodeToJSON() -> Any {
        let json: [String: Any?] = [
            "topicHandle": topicHandle,
            "createdTime": createdTime,
            "user": user.encodeToJSON(),
            "imageUrl": imageUrl,
            "imageHandle": imageHandle,
            "title": title,
            "text": text,
            "deepLink": deepLink,
            "totalLikes": totalLikes,
            "totalComments": totalComments,
            "liked": liked,
            "pinned": pinned,
        ]
        return json.flatMap { $0 }
    }
}

extension Post {
    
    init?(data: TopicView) {

        // must have user
        guard let userCompactView = data.user else {
            return nil
        }
        
        let user = User(compactView: userCompactView)
        
        // must have this data, else - invalid
        guard
            let handle = data.topicHandle,
            let text = data.text,
            let pinned = data.pinned,
            let liked = data.liked,
            let imageHandle = data.blobHandle,
            let imageURL = data.blobUrl,
            let date = data.createdTime,
            let likesNumber64 = data.totalLikes,
            let commentsNumber64 = data.totalComments,
            let likesNumber = Int(exactly: likesNumber64),
            let commentsNumber = Int(exactly: commentsNumber64),
            let title = data.title else {
                return nil
        }
        
        self.init(topicHandle: handle,
                  createdTime: date,
                  user: user,
                  imageUrl: imageURL,
                  imageHandle: imageHandle,
                  title: title,
                  text: text,
                  deepLink: data.deepLink,
                  totalLikes: likesNumber,
                  totalComments: commentsNumber,
                  liked: liked,
                  pinned: pinned)
    }
    
}

// MARK: Feed
struct Feed {
    var fetchID: String
    var feedType: FeedType
    var items: [Post]
    var cursor: String? = nil
}

// MARK: Service Query Result
struct FeedFetchResult {
    var posts: [Post] = []
    var error: Error?
    var cursor: String?
}

extension FeedFetchResult {
    init(response: FeedResponseTopicView?) {
        
        if let items = response?.data {
            
            // ignore error on corrupted data
            posts = items.map(Post.init).flatMap{ $0 }
        }
        
        error = nil
        cursor = response?.cursor
    }
    
    init(error: Error) {
        self.error = FeedServiceError.failedToFetch(message: error.localizedDescription)
        posts = []
        cursor = nil
    }
}

extension FeedFetchResult {
    
    static func mock() -> FeedFetchResult {
        var result = FeedFetchResult()
        
        let number = arc4random() % 5 + 1
        
        for index in 0..<number {
            result.posts.append(Post.mock(seed: Int(index)))
        }
        return result
    }
}

