//
//  Router.swift
//  MSGP
//
//  Created by Akvelon on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import EnvoyAmbassador

class APIRouter: Router {
    override public init() {
        super.init()
        
        self["/topics/Today"] = APIResponse(handler: {
            _ -> Any in return self.makeTopics(interval: "Today", length: 2)
        })
        self["/topics/ThisWeek"] = APIResponse(handler: {
            _ -> Any in return self.makeTopics(interval: "ThisWeek", length: 2)
        })
        self["/topics/ThisMonth"] = APIResponse(handler: {
            _ -> Any in return self.makeTopics(interval: "ThisMonth", length: 2)
        })
        self["/topics/AllTime"] = APIResponse(handler: {
            _ -> Any in return self.makeTopics(interval: "AllTime", length: 2)
        })
    }
    
    func makeTopics(interval: String, length: Int = 1) -> Any {
        var topics = ["data": [], "cursor": nil]
        
        for i in 1...length {
            let topic = Templates.load(name: "topic",
                                       replacements: ["title": interval + String(i),
                                                      "topicHandle": interval + String(i),
                                                      "text": interval + "text" + String(i)],
                                       preReplacements: ["createdTime": interval])
            topics["data"]!!.append(topic)
        }
        
        return topics
    }
}

