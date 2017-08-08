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
        
        self["/v0.6/topics/?(.*(?<!likes)$)"] = APIResponse(serviceName: "topics") { environ, sendJSON -> Void in
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
                    if captures.count > 0 && captures[0] != ""{
                        interval = captures[0]
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
        
        self["/v0.6/topics/(.*)/likes"] = APIResponse(serviceName: "likes") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
                case "POST":
                    sendJSON(Templates.load(name: "likes_post"))
                default:
                    break
            }
        }
        
        self["/v0.6/topics/(.*)/likes/me"] = APIResponse(serviceName: "likes") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "DELETE":
                sendJSON(Templates.load(name: "likes_delete"))
            default:
                break
            }
        }
        
        self["/v0.6/users/me/pins"] = APIResponse(serviceName: "pins") { environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "POST":
                JSONReader.read(input) { json in
                    APIState.setLatestData(forService: "pins", data: json)
                    sendJSON(Templates.load(name: "pins_post"))
                }
            default:
                break
            }
        }
        
        self["/v0.6/users/me/pins/(.*)"] = APIResponse(serviceName: "pins") { environ, sendJSON -> Void in
            let method = environ["REQUEST_METHOD"] as! String
            switch method {
            case "DELETE":
                sendJSON(Templates.load(name: "pins_delete"))
            default:
                break
            }
        }
        
        self["/v0.6/images/(UserPhoto|ContentBlob|AppIcon)"] = APIResponse(serviceName: "images") { environ, sendJSON -> Void in
            let input = environ["swsgi.input"] as! SWSGIInput
            DataReader.read(input) { data in
                APIState.setLatestDataAsString(forService: "images", data: String(data: data, encoding: .utf8) as String!)
                sendJSON(Templates.load(name: "image_post", values: ["blobHandle": UUID().uuidString]))
            }
        }
        
        self["/v0.6/images/(.*)"] = DataResponse(handler: {
            environ, sendData -> Void in
            let image = UIImagePNGRepresentation(UIImage(color: UIColor.cyan, size: CGSize(width: 100, height: 100))!)!
            sendData(image)
        })
        
        self["/images/(.*)"] = self["/v0.6/images/(.*)"]

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
        APIState.addRequest(searchPath)
        
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

