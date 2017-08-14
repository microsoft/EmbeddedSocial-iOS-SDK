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
                values = ["text": "topic text" + String(i)]
            }
            
            let topic = Templates.load(name: "topic",
                                       values: values)
            topics.append(topic)
        }
        
        return ["data": topics, "cursor": String(cursor + limit)]
    }
    
    class func loadFollowers(cursor: Int = 0, limit: Int = 10) -> Any {
        var followers: Array<[String: Any]> = []
        
        for i in cursor...cursor + limit - 1 {
            let values = ["firstName": "User",
                          "lastName": "Follower" + String(i),
                          "userHandle": "UserFollower" + String(i),
                          "photoHandle": APIConfig.showUserImages ? UUID().uuidString : NSNull(),
                          "photoUrl": APIConfig.showUserImages ? String(format: "http://localhost:8080/images/%@", UUID().uuidString) : NSNull()] as [String: Any]
            
            let follower = Templates.load(name: "follower", values: values)
            
            followers.append(follower)
        }
        
        return ["data": followers, "cursor": String(cursor + limit)]
    }
    
}
