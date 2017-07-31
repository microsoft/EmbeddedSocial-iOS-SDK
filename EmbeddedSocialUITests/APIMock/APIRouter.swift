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
        
        self["/v0.6/topics"] = APIResponse(serviceName: "topics") { environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            JSONReader.read(input) { json in
                APIState.setLatestData(forService: "topics", data: json)
                sendJSON(Templates.load(name: "topic_post", replacements: ["topicHandle": UUID().uuidString]))
            }
        }
        
        self["/v0.6/topics/(Today|ThisWeek|ThisMonth|AllTime)"] = APIResponse(serviceName: "topics", handler: {
            environ -> Any in
            let captures = environ["ambassador.router_captures"] as! [String]
            return self.makeTopics(interval: captures[0], length: 2)
        })
        
        
        self["/v0.6/images/(.*)"] = APIResponse(serviceName: "images") { environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            DataReader.read(input) { data in
                APIState.setLatestDataAsString(forService: "images", data: String(data: data, encoding: .utf8) as String!)
                sendJSON(Templates.load(name: "image_post", replacements: ["blobHandle": UUID().uuidString]))
            }
        }
    }
    
    func makeTopics(interval: String, length: Int = 1) -> Any {
        var topics: Dictionary = ["data": [], "cursor": nil]
        
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
        
        if let (webApp, captures) = matchRoute(to: path) {
            var environ = environ
            environ["ambassador.router_captures"] = captures
            webApp.app(environ, startResponse: startResponse, sendBody: sendBody)
            return
        }
        return notFoundResponse.app(environ, startResponse: startResponse, sendBody: sendBody)
    }
    
    private func matchRoute(to searchPath: String) -> (WebApp, [String])? {
        print("Request: " + searchPath)
        if routes[searchPath] != nil {
            return (routes[searchPath]!, [])
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
                return (route, captures)
            }
        }
        return nil
    }
}

