//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class BundleHelper {
    
    func getCurrentBundle() -> Bundle {
        return Bundle(for: type(of: self))
    }
    
}

class Templates {
    
    open static var bundle = BundleHelper().getCurrentBundle()
    
    class func load(name: String, values: [String: Any] = [:]) -> [String: Any] {
        let path = Templates.bundle.path(forResource: name, ofType: "json")!
        
        let content = try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
        
        var mergedValues = APIConfig.values
        mergedValues.update(other: values)
        
        var json = try! JSONSerialization.jsonObject(with: content.data(using: .utf8)!, options: []) as! [String: Any]
        
        for (key, value) in mergedValues {
            let parts = key.components(separatedBy: "->")
            if parts.count > 1 {
                if let temp = json[parts[0]] {
                    var tempDict = temp as! [String: Any]
                    tempDict[parts[1]] = value
                    json[parts[0]] = tempDict
                }
                //                var temp = json[parts[0]] as! [String: Any]
            } else {
                json[parts[0]] = value
            }
        }
        
        return json
    }
    
    class func loadTopics(interval: String, cursor: Int = 0, limit: Int = 10) -> Any {
        var topics: Array<[String: Any]> = []
        
        for i in cursor...cursor + limit - 1 {
            var values = ["title": interval + String(i),
                          "topicHandle": interval + String(i),
                          "lastUpdatedTime": Date().ISOString,
                          "createdTime": Date().ISOString,
                          "blobType": APIConfig.showTopicImages ? "Image": "Unknown",
                          "blobHandle": APIConfig.showTopicImages ? UUID().uuidString : NSNull(),
                          "blobUrl": APIConfig.showTopicImages ? String(format: "http://localhost:8080/images/%@", UUID().uuidString) : NSNull()] as [String: Any]
            
            if APIConfig.numberedTopicTeasers {
                values["text"] = "topic text" + String(i)
            }
            
            if APIConfig.loadMyTopics {
                values["user->userHandle"] = "me"
            }
            
            let topic = Templates.load(name: "topic",
                                       values: values)
            topics.append(topic)
        }
        
        return ["data": topics, "cursor": String(cursor + limit)]
    }
    
    class func loadFollowers(firstName: String, lastName: String, cursor: Int = 0, limit: Int = 10) -> Any {
        var followers: Array<[String: Any]> = []
        
        for i in cursor...cursor + limit - 1 {
            let values = ["firstName": firstName,
                          "lastName": lastName + String(i),
                          "userHandle": firstName + lastName + String(i),
                          "photoHandle": APIConfig.showUserImages ? UUID().uuidString : NSNull(),
                          "photoUrl": APIConfig.showUserImages ? String(format: "http://localhost:8080/images/%@", UUID().uuidString) : NSNull()] as [String: Any]
            
            let follower = Templates.load(name: "follower", values: values)
            
            followers.append(follower)
        }
        
        return ["data": followers, "cursor": String(cursor + limit)]
    }
    
    class func loadComments(cursor: Int = 0, limit: Int = 10) -> Any {
        var comments: Array<[String: Any]> = []
        
        for i in cursor...cursor + limit - 1 {
            var values: [String: Any]
            values = ["commentHandle": "commentHandle" + String(i),
                      "createdTime": Date().ISOString]
            
            if APIConfig.numberedCommentLikes {
                values["totalLikes"] = i
            }
            
            var comment = Templates.load(name: "comment", values: values)
            
            if APIConfig.showCommentHandleInTeaser {
                comment["text"] = comment["commentHandle"]
            }
            
            comments.append(comment)
        }
        
        return ["data": comments, "cursor": String(cursor + limit)]
    }
    
    class func loadReplies(cursor: Int = 0, limit: Int = 10) -> Any {
        var comments: Array<[String: Any]> = []
        
        for i in cursor...cursor + limit - 1 {
            var values: [String: Any]
            values = ["replyHandle": "replyHandle" + String(i)]
            
            if APIConfig.numberedCommentLikes {
                values["totalLikes"] = i
            }
            
            let comment = Templates.load(name: "reply", values: values)
            
            comments.append(comment)
        }
        print(comments.count)
        return ["data": comments, "cursor": String(cursor + limit)]
    }
    
    class func loadActivities(cursor: Int, limit: Int = 10) -> Any {
        var activities: Array<[String: Any]> = []
        
        for i in cursor...cursor + limit - 1 {
            let followers = (loadFollowers(firstName: "Name", lastName: "LastName", cursor: i, limit: i + 1) as! [String : Any])["data"] as! [Any]
            
            let values = ["activityHandle" : "String",
                          "createdTime"    : Date().ISOString,
                          "actorUsers"     : followers,
                          "actedOnUser"    : followers[i],
                          "activityType"   : "Like",
                          "actedOnContent" : [
                            "contentType"   : "Comment",
                            "text"          : "TextExample",
                            "blobHandle"    : UUID().uuidString]]
            
            activities.append(load(name: "activity", values: values))
        }
        
        return ["data": activities, "cursor": String(cursor + limit)]
    }
    
    class func loadHashtags(_ limit: Int = 10) -> [String] {
        return (0..<limit).map { i in
            "#hashtag\(i)"
        }
    }
    
}
