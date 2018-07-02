//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import EnvoyAmbassador
import Embassy

open class APIRouter: WebApp {
    var routes: [String: WebApp] = [:]
    open var notFoundResponse: WebApp = DataResponse(
        statusCode: 404,
        statusMessage: "Not found"
    )
    private let semaphore = DispatchSemaphore(value: 1)
    
    public init() {
        self["/"] = APIResponse(handler: {
            _ -> Any in
            return ["message": "It works!"]
        })
        
        self["/v0.7/topics/(.*(?<!popular|comments)$)"] = APIResponse(serviceName: "topics") {environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            if method == "PUT" {
                let input = environ["swsgi.input"] as! SWSGIInput
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "topicUpdate", data: json)
                    sendJSON(Templates.load(name: "topic_put"))
                }
                return
            }
            if method == "GET" {
                let query = URLParametersReader.parseURLParameters(environ: environ)
                
                // Load one topic
                if query.isEmpty {
                    sendJSON(Templates.load(name: "topic"))
                    return
                }
                
                let captures = environ["ambassador.router_captures"] as! [String]
                var interval = "topics"
                if captures.count > 0 && captures[0] != "" {
                    interval = ""
                    for i in 0...captures.count - 1 {
                        interval += captures[i]
                    }
                }
                print(query)
                let cursor = query["cursor"] ?? "0"
                if let limit = query["limit"] {
                    sendJSON(Templates.loadTopics(interval: interval, cursor: Int(cursor)!, limit: Int(limit)!))
                } else {
                    sendJSON(Templates.loadTopics(interval: interval))
                }
                return
            }
            sendJSON(Templates.load(name: "topic"))
        }
        
        self["/v0.7/topics/(popular.*$)"] = APIResponse(serviceName: "topics") { environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "POST":
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "topics", data: json)
                    sendJSON(Templates.load(name: "topic_post", values: ["topicHandle": UUID().uuidString]))
                }
            default:
                let query = URLParametersReader.parseURLParameters(environ: environ)
                let captures = environ["ambassador.router_captures"] as! [String]
                var interval = "topics"
                if captures.count > 0 && captures[0] != "" {
                    interval = ""
                    for i in 0...captures.count - 1 {
                        interval += captures[i]
                    }
                }
                print(query)
                let cursor = query["cursor"] ?? "0"
                if let limit = query["limit"] {
                    sendJSON(Templates.loadTopics(interval: interval, cursor: Int(cursor)!, limit: Int(limit)!))
                } else {
                    sendJSON(Templates.loadTopics(interval: interval))
                }
            }
        }
        
        self["/v0.7/topics"] = self["/v0.7/topics/(popular.*$)"]
        self["/v0.7/users/(.*)/topics/?(.*)"] = self["/v0.7/topics/(popular.*$)"]
        self["/v0.7/users/me/following/combined"] = self["/v0.7/topics/(popular.*$)"]
        
        self["/v0.7/topics/(.*)/comments"] = APIResponse(serviceName: "comments") {environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "POST":
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "comments", data: json)
                    sendJSON(Templates.load(name: "comment_post", values: ["commentHandle": UUID().uuidString]))
                }
            default:
                let query = URLParametersReader.parseURLParameters(environ: environ)
                print(query)
                let cursor = query["cursor"] ?? "0"
                if let limit = query["limit"] {
                    sendJSON(Templates.loadComments(cursor: Int(cursor)!, limit: Int(limit)!))
                } else {
                    sendJSON(Templates.loadComments())
                }
            }
        }
        
        self["/v0.7/comments/(.*)/replies"] = APIResponse(serviceName: "replies") {environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "POST":
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "replies", data: json)
                    sendJSON(Templates.load(name: "reply_post", values: ["replyHandle": UUID().uuidString]))
                }
            default:
                let query = URLParametersReader.parseURLParameters(environ: environ)
                print(query)
                let cursor = query["cursor"] ?? "0"
                if let limit = query["limit"] {
                    sendJSON(Templates.loadReplies(cursor: Int(cursor)!, limit: Int(limit)!))
                } else {
                    sendJSON(Templates.loadReplies())
                }
            }
        }
        
        self["/v0.7/comments/(.*)/reports"] = APIResponse(serviceName: "reports") {environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            let method = environ["REQUEST_METHOD"] as! String
            if method == "POST" {
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "reports", data: json)
                    sendJSON(Templates.load(name: "comment_report_post"))
                }
            }
        }
        
        self["/v0.7/topics/(.*)/likes"] = APIResponse(serviceName: "likes") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "POST":
                sendJSON(Templates.load(name: "likes_post"))
            default:
                break
            }
        }
        
        self["/v0.7/topics/(.*)/likes/me"] = APIResponse(serviceName: "likes") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "DELETE":
                sendJSON(Templates.load(name: "likes_delete"))
            default:
                break
            }
        }
        
        self["/v0.7/users/me/pins"] = APIResponse(serviceName: "pins") { environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "GET":
                let query = URLParametersReader.parseURLParameters(environ: environ)
                let captures = environ["ambassador.router_captures"] as! [String]
                var interval = "pins"
                if captures.count > 0 && captures[0] != "" {
                    interval = ""
                    for i in 0...captures.count - 1 {
                        interval += captures[i]
                    }
                }
                print(query)
                let cursor = query["cursor"] ?? "0"
                
                APIConfig.values = ["pinned" : true]
                
                if let limit = query["limit"] {
                    sendJSON(Templates.loadTopics(interval: interval, cursor: Int(cursor)!, limit: Int(limit)!))
                } else {
                    sendJSON(Templates.loadTopics(interval: interval))
                }
                break
                
            case "POST":
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "pins", data: json)
                    sendJSON(Templates.load(name: "pins_post"))
                }
            default:
                break
            }
        }
        
        self["/v0.7/users/me/pins/(.*)"] = APIResponse(serviceName: "pins") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "DELETE":
                sendJSON(Templates.load(name: "pins_delete"))
            default:
                break
            }
        }
        
        self["/v0.7/images/(UserPhoto|ContentBlob|AppIcon)"] = APIResponse(serviceName: "images") { environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            DataReader.read(input) { data in
                APIState.setLatestDataAsString(forService: "images", data: String(data: data, encoding: .utf8) as String!)
                sendJSON(Templates.load(name: "image_post", values: ["blobHandle": UUID().uuidString]))
            }
        }
        
        self["/v0.7/images/(.*)"] = DataResponse(handler: {
            environ, sendData -> Void in
            let image = UIImagePNGRepresentation(UIImage(color: UIColor.cyan, size: CGSize(width: 100, height: 100))!)!
            sendData(image)
        })
        
        self["/images/(.*)"] = self["/v0.7/images/(.*)"]
        
        self["/v0.7/users/(.*(?<!follow))"] = APIResponse(serviceName: "me") { environ, sendJSON -> Void in
            let path = environ["PATH_INFO"] as! String
            let method = environ["REQUEST_METHOD"] as! String
            
            if path.contains("blocked_users") {
                let input = environ["swsgi.input"] as! SWSGIInput
                switch method {
                case "POST":
                    JSONReader.read(input) { json in
                        APIState.setLatestData(forService: "blockedUsers", data: json)
                        sendJSON(Templates.load(name: "block_user_post"))
                    }
                case "DELETE":
                    sendJSON(Templates.load(name: "block_user_delete"))
                default:
                    let query = URLParametersReader.parseURLParameters(environ: environ)
                    let cursor = query["cursor"] ?? "0"
                    print(query)
                    var sendedJSON: Any
                    if let limit = query["limit"] {
                        sendedJSON = Templates.loadFollowers(firstName: "Blocked", lastName: "User", cursor: Int(cursor)!, limit: Int(limit)!)
                    } else {
                        sendedJSON = Templates.loadFollowers(firstName: "Blocked", lastName: "Blocked")
                    }
                    sendJSON(sendedJSON)
                    APIState.setLatestResponse(forService: "blockedUsers", data: sendedJSON)
                }
                return
            }
            
            switch method {
            case "POST":
                break
            default:
                let values = APIConfig.loadMyTopics ? ["userHandle" : "me"] : ["userHandle" : "OtherUser"]
                sendJSON(Templates.load(name: "user", values: values))
            }
        }
        
        self["/v0.7/users/me/followers"] = APIResponse(serviceName: "followers") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "POST":
                let input = environ["swsgi.input"] as! SWSGIInput
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "followers", data: json)
                    sendJSON(Templates.load(name: "follower_post"))
                }
                
            default:
                let query = URLParametersReader.parseURLParameters(environ: environ)
                print(query)
                let cursor = query["cursor"] ?? "0"
                if let limit = query["limit"] {
                    sendJSON(Templates.loadFollowers(firstName: "User", lastName: "Follower", cursor: Int(cursor)!, limit: Int(limit)!))
                } else {
                    sendJSON(Templates.loadFollowers(firstName: "User", lastName: "Follower"))
                }
            }
        }
        
        self["/v0.7/users/me/visibility"] = APIResponse(serviceName: "visibility") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            if method == "PUT" {
                let input = environ["swsgi.input"] as! SWSGIInput
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "visibility", data: json)
                    sendJSON(Templates.load(name: "user"))
                }
            }
        }
        
        self["/v0.7/users/me/following/users/?(.*)"] = APIResponse(serviceName: "followers") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            let input = environ["swsgi.input"] as! SWSGIInput
            switch method {
            case "POST":
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "followers", data: json)
                    sendJSON(Templates.load(name: "follower_post"))
                }
            case "DELETE":
                sendJSON(Templates.load(name: ""))
            default:
                let query = URLParametersReader.parseURLParameters(environ: environ)
                let cursor = query["cursor"] ?? "0"
                if let limit = query["limit"] {
                    sendJSON(Templates.loadFollowers(firstName: "User", lastName: "Following", cursor: Int(cursor)!, limit: Int(limit)!))
                } else {
                    sendJSON(Templates.loadFollowers(firstName: "User", lastName: "Following"))
                }
            }
        }
        
        self["/v0.7/users/me/info"] = APIResponse(serviceName: "me") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            let input = environ["swsgi.input"] as! SWSGIInput
            switch method {
            case "PUT":
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "me", data: json)
                    sendJSON(Templates.load(name: "info"))
                }
            default:
                break
            }
        }
        
        self["/v0.7/search/topics"] = APIResponse(serviceName: "search") { environ, sendJSON -> Void in
            let query = URLParametersReader.parseURLParameters(environ: environ)
            print (query)
            let cursor = query["cursor"] ?? "0"
            if let limit = query["limit"] {
                sendJSON(Templates.loadTopics(interval: query["query"]!, cursor: Int(cursor)!, limit: Int(limit)!))
            } else {
                sendJSON(Templates.loadTopics(interval: query["query"]!))
            }
        }
        
        self["/v0.7/search/users"] = APIResponse(serviceName: "search") { environ, sendJSON -> Void in
            let query = URLParametersReader.parseURLParameters(environ: environ)
            print(query)
            let cursor = query["cursor"] ?? "0"
            if let limit = query["limit"] {
                sendJSON(Templates.loadFollowers(firstName: query["query"]!, lastName: "", cursor: Int(cursor)!, limit: Int(limit)!))
            } else {
                sendJSON(Templates.loadFollowers(firstName: query["query"]!, lastName: ""))
            }
        }
        
        self["/v0.7/users/me/pending_users"] = APIResponse(serviceName: "pendingUsers") { environ, sendJSON -> Void in
            let query = URLParametersReader.parseURLParameters(environ: environ)
            
            print("PENDING USERS QUERY: \(query)")
            
            let cursor = query["cursor"] ?? "0"
            if let limit = query["limit"] {
                sendJSON(Templates.loadFollowers(firstName: "Pending", lastName: "Request", cursor: Int(cursor)!, limit: Int(limit)!))
            } else {
                sendJSON(Templates.loadFollowers(firstName: "Pending", lastName: "Request"))
            }
        }
        
        self["/v0.7/users/me/following/activities"] = APIResponse(serviceName: "activities") { environ, sendJSON -> Void in
            let query = URLParametersReader.parseURLParameters(environ: environ)
            let cursor = Int(query["cursor"] ?? "0")!
            
            print("ACTIVITIES QUERY: \(query)")
            
            if let limit = Int(query["limit"] ?? "") {
                sendJSON(Templates.loadActivities(cursor: cursor, limit: limit))
            } else {
                sendJSON(Templates.loadActivities(cursor: cursor))
            }
        }
        
        self["/v0.7/users/me/notifications"] = APIResponse(serviceName: "notifications") { environ, sendJSON -> Void in
            let query = URLParametersReader.parseURLParameters(environ: environ)
            let cursor = Int(query["cursor"] ?? "0")!
            
            print("NOTIFICATIONS QUERY: \(query)")
            
            if let limit = Int(query["limit"] ?? "") {
                sendJSON(Templates.loadActivities(cursor: cursor, limit: limit))
            } else {
                sendJSON(Templates.loadActivities(cursor: cursor))
            }
        }
        
        self["/v0.7/hashtags/trending"] = APIResponse(serviceName: "hashtags") { _, sendJSON -> Void in
            sendJSON(Templates.loadHashtags())
        }
        
        self["/v0.7/users/popular"] = APIResponse(serviceName: "") { _, sendJSON -> Void in
            sendJSON(Templates.loadFollowers(firstName: "Suggested", lastName: "User"))
        }
        
    }
    
    open subscript(path: String) -> WebApp? {
        get {
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            defer {
                semaphore.signal()
            }
            return routes[path]
        }
        
        set {
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            defer {
                semaphore.signal()
            }
            routes[path] = newValue!
        }
    }
    
    open func app(
        _ environ: [String: Any],
        startResponse: @escaping ((String, [(String, String)]) -> Void),
        sendBody: @escaping ((Data) -> Void)
        ) {
        let path = environ["PATH_INFO"] as! String
        
        APIState.latestRequstMethod = environ["REQUEST_METHOD"] as! String
        
        if let (webApp, captures) = matchRoute(to: path) {
            var environ = environ
            environ["ambassador.router_captures"] = captures
            webApp.app(environ, startResponse: startResponse, sendBody: sendBody)
            return
        }
        return notFoundResponse.app(environ, startResponse: startResponse, sendBody: sendBody)
    }
    
}

// MARK: - Private

extension APIRouter {
    
    fileprivate func matchRoute(to searchPath: String) -> (WebApp, [String])? {
        print("Request: " + searchPath + " - \(APIConfig.isReachable ? "Online" : "Offline")")
        APIState.addRequest(searchPath)
        
        if !APIConfig.isReachable {
            let error: WebApp = DataResponse(statusCode: 500, statusMessage: "Internal Server Error from UI Test")
            return (error, [])
        }
        
        if APIConfig.wrongResponses {
            let wrongResponse = generateWrongResponse()
            return (wrongResponse, [])
        }
        
        if let route = routes[searchPath] {
            return (makeDelayedIfNeeded(route), [])
        }
        
        for (path, route) in routes {
            
            if path.range(of: "(") == nil {
                continue
            }
            
            let regex = try! NSRegularExpression(pattern: path, options: [])
            let matches = regex.matches(
                in: searchPath,
                options: [],
                range: NSRange(location: 0, length: searchPath.characters.count)
            )
            if !matches.isEmpty {
                let searchPath = searchPath as NSString
                let match = matches[0]
                var captures = [String]()
                for rangeIdx in 1 ..< match.numberOfRanges {
                    captures.append(searchPath.substring(with: match.rangeAt(rangeIdx)))
                }
                return (makeDelayedIfNeeded(route), captures)
            }
        }
        return nil
    }
    
    private func makeDelayedIfNeeded(_ response: WebApp) -> WebApp {
        var resultResponse = response
        if APIConfig.delayedResponses {
            resultResponse = DelayResponse(response, delay: .delay(seconds: APIConfig.responsesDelay))
        }
        return resultResponse
    }
    
    private func generateWrongResponse() -> WebApp {
        let response: WebApp = WrongAPIResponse { (environment, sendJSON) in
            let randomResponse = Templates.loadWrongResponse()
            NSLog("Random response: \(randomResponse)")
            sendJSON(randomResponse)
        }
        return response
    }
    
}
