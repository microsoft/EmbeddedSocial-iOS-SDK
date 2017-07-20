//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> Any
}

public enum ErrorResponse : Error {
    case Error(Int, Data?, Error)
}

open class Response<T> {
    open let statusCode: Int
    open let header: [String: String]
    open let body: T?

    public init(statusCode: Int, header: [String: String], body: T?) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

private var once = Int()
class Decoders {
    static fileprivate var decoders = Dictionary<String, ((AnyObject) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0) as AnyObject }
    }

    static func decode<T>(clazz: T.Type, discriminator: String, source: AnyObject) -> T {
        let key = discriminator;
        if let decoder = decoders[key] {
            return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map { Decoders.decode(clazz: T.self, source: $0) }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key:T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value)
        }
        return dictionary
    }

    static func decode<T>(clazz: T.Type, source: AnyObject) -> T {
        initialize()
        if T.self is Int32.Type && source is NSNumber {
            return source.int32Value as! T;
        }
        if T.self is Int64.Type && source is NSNumber {
            return source.int64Value as! T;
        }
        if T.self is UUID.Type && source is String {
            return UUID(uuidString: source as! String) as! T
        }
        if source is T {
            return source as! T
        }
        if T.self is Data.Type && source is String {
            return Data(base64Encoded: source as! String) as! T
        }

        let key = "\(T.self)"
        if let decoder = decoders[key] {
           return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss"
        ].map { (format: String) -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject) -> Date in
           if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return date
                    }
                }
            }
            if let sourceInt = source as? Int64 {
                // treat as a java date
                return Date(timeIntervalSince1970: Double(sourceInt / 1000) )
            }
            fatalError("formatter failed to parse \(source)")
        } 

        // Decoder for [ActivityView]
        Decoders.addDecoder(clazz: [ActivityView].self) { (source: AnyObject) -> [ActivityView] in
            return Decoders.decode(clazz: [ActivityView].self, source: source)
        }
        // Decoder for ActivityView
        Decoders.addDecoder(clazz: ActivityView.self) { (source: AnyObject) -> ActivityView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ActivityView()
            instance.activityHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["activityHandle"] as AnyObject?)
            instance.createdTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["createdTime"] as AnyObject?)
            if let activityType = sourceDictionary["activityType"] as? String { 
                instance.activityType = ActivityView.ActivityType(rawValue: (activityType))
            }
            
            instance.actorUsers = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["actorUsers"] as AnyObject?)
            instance.actedOnUser = Decoders.decodeOptional(clazz: UserCompactView.self, source: sourceDictionary["actedOnUser"] as AnyObject?)
            instance.actedOnContent = Decoders.decodeOptional(clazz: ContentCompactView.self, source: sourceDictionary["actedOnContent"] as AnyObject?)
            instance.totalActions = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["totalActions"] as AnyObject?)
            instance.unread = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["unread"] as AnyObject?)
            instance.app = Decoders.decodeOptional(clazz: AppCompactView.self, source: sourceDictionary["app"] as AnyObject?)
            return instance
        }


        // Decoder for [AppCompactView]
        Decoders.addDecoder(clazz: [AppCompactView].self) { (source: AnyObject) -> [AppCompactView] in
            return Decoders.decode(clazz: [AppCompactView].self, source: source)
        }
        // Decoder for AppCompactView
        Decoders.addDecoder(clazz: AppCompactView.self) { (source: AnyObject) -> AppCompactView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = AppCompactView()
            instance.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            instance.iconHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["iconHandle"] as AnyObject?)
            instance.iconUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["iconUrl"] as AnyObject?)
            if let platformType = sourceDictionary["platformType"] as? String { 
                instance.platformType = AppCompactView.PlatformType(rawValue: (platformType))
            }
            
            instance.deepLink = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deepLink"] as AnyObject?)
            instance.storeLink = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["storeLink"] as AnyObject?)
            return instance
        }


        // Decoder for [BuildsCurrentResponse]
        Decoders.addDecoder(clazz: [BuildsCurrentResponse].self) { (source: AnyObject) -> [BuildsCurrentResponse] in
            return Decoders.decode(clazz: [BuildsCurrentResponse].self, source: source)
        }
        // Decoder for BuildsCurrentResponse
        Decoders.addDecoder(clazz: BuildsCurrentResponse.self) { (source: AnyObject) -> BuildsCurrentResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = BuildsCurrentResponse()
            instance.dateAndTime = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dateAndTime"] as AnyObject?)
            instance.commitHash = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["commitHash"] as AnyObject?)
            instance.hostname = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostname"] as AnyObject?)
            instance.serviceApiVersion = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serviceApiVersion"] as AnyObject?)
            instance.dirtyFiles = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["dirtyFiles"] as AnyObject?)
            return instance
        }


        // Decoder for [CommentView]
        Decoders.addDecoder(clazz: [CommentView].self) { (source: AnyObject) -> [CommentView] in
            return Decoders.decode(clazz: [CommentView].self, source: source)
        }
        // Decoder for CommentView
        Decoders.addDecoder(clazz: CommentView.self) { (source: AnyObject) -> CommentView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = CommentView()
            instance.commentHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["commentHandle"] as AnyObject?)
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            instance.createdTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["createdTime"] as AnyObject?)
            instance.lastUpdatedTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["lastUpdatedTime"] as AnyObject?)
            instance.user = Decoders.decodeOptional(clazz: UserCompactView.self, source: sourceDictionary["user"] as AnyObject?)
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            if let blobType = sourceDictionary["blobType"] as? String { 
                instance.blobType = CommentView.BlobType(rawValue: (blobType))
            }
            
            instance.blobHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobHandle"] as AnyObject?)
            instance.blobUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobUrl"] as AnyObject?)
            instance.language = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["language"] as AnyObject?)
            instance.totalLikes = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["totalLikes"] as AnyObject?)
            instance.totalReplies = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["totalReplies"] as AnyObject?)
            instance.liked = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["liked"] as AnyObject?)
            if let contentStatus = sourceDictionary["contentStatus"] as? String { 
                instance.contentStatus = CommentView.ContentStatus(rawValue: (contentStatus))
            }
            
            return instance
        }


        // Decoder for [ContentCompactView]
        Decoders.addDecoder(clazz: [ContentCompactView].self) { (source: AnyObject) -> [ContentCompactView] in
            return Decoders.decode(clazz: [ContentCompactView].self, source: source)
        }
        // Decoder for ContentCompactView
        Decoders.addDecoder(clazz: ContentCompactView.self) { (source: AnyObject) -> ContentCompactView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ContentCompactView()
            if let contentType = sourceDictionary["contentType"] as? String { 
                instance.contentType = ContentCompactView.ContentType(rawValue: (contentType))
            }
            
            instance.contentHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["contentHandle"] as AnyObject?)
            instance.parentHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentHandle"] as AnyObject?)
            instance.rootHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["rootHandle"] as AnyObject?)
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            if let blobType = sourceDictionary["blobType"] as? String { 
                instance.blobType = ContentCompactView.BlobType(rawValue: (blobType))
            }
            
            instance.blobHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobHandle"] as AnyObject?)
            instance.blobUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobUrl"] as AnyObject?)
            return instance
        }


        // Decoder for [CountResponse]
        Decoders.addDecoder(clazz: [CountResponse].self) { (source: AnyObject) -> [CountResponse] in
            return Decoders.decode(clazz: [CountResponse].self, source: source)
        }
        // Decoder for CountResponse
        Decoders.addDecoder(clazz: CountResponse.self) { (source: AnyObject) -> CountResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = CountResponse()
            instance.count = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["count"] as AnyObject?)
            return instance
        }


        // Decoder for [DeleteTopicNameRequest]
        Decoders.addDecoder(clazz: [DeleteTopicNameRequest].self) { (source: AnyObject) -> [DeleteTopicNameRequest] in
            return Decoders.decode(clazz: [DeleteTopicNameRequest].self, source: source)
        }
        // Decoder for DeleteTopicNameRequest
        Decoders.addDecoder(clazz: DeleteTopicNameRequest.self) { (source: AnyObject) -> DeleteTopicNameRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = DeleteTopicNameRequest()
            if let publisherType = sourceDictionary["publisherType"] as? String { 
                instance.publisherType = DeleteTopicNameRequest.PublisherType(rawValue: (publisherType))
            }
            
            return instance
        }


        // Decoder for [FeedResponseActivityView]
        Decoders.addDecoder(clazz: [FeedResponseActivityView].self) { (source: AnyObject) -> [FeedResponseActivityView] in
            return Decoders.decode(clazz: [FeedResponseActivityView].self, source: source)
        }
        // Decoder for FeedResponseActivityView
        Decoders.addDecoder(clazz: FeedResponseActivityView.self) { (source: AnyObject) -> FeedResponseActivityView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = FeedResponseActivityView()
            instance.data = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["data"] as AnyObject?)
            instance.cursor = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cursor"] as AnyObject?)
            return instance
        }


        // Decoder for [FeedResponseCommentView]
        Decoders.addDecoder(clazz: [FeedResponseCommentView].self) { (source: AnyObject) -> [FeedResponseCommentView] in
            return Decoders.decode(clazz: [FeedResponseCommentView].self, source: source)
        }
        // Decoder for FeedResponseCommentView
        Decoders.addDecoder(clazz: FeedResponseCommentView.self) { (source: AnyObject) -> FeedResponseCommentView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = FeedResponseCommentView()
            instance.data = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["data"] as AnyObject?)
            instance.cursor = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cursor"] as AnyObject?)
            return instance
        }


        // Decoder for [FeedResponseReplyView]
        Decoders.addDecoder(clazz: [FeedResponseReplyView].self) { (source: AnyObject) -> [FeedResponseReplyView] in
            return Decoders.decode(clazz: [FeedResponseReplyView].self, source: source)
        }
        // Decoder for FeedResponseReplyView
        Decoders.addDecoder(clazz: FeedResponseReplyView.self) { (source: AnyObject) -> FeedResponseReplyView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = FeedResponseReplyView()
            instance.data = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["data"] as AnyObject?)
            instance.cursor = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cursor"] as AnyObject?)
            return instance
        }


        // Decoder for [FeedResponseTopicView]
        Decoders.addDecoder(clazz: [FeedResponseTopicView].self) { (source: AnyObject) -> [FeedResponseTopicView] in
            return Decoders.decode(clazz: [FeedResponseTopicView].self, source: source)
        }
        // Decoder for FeedResponseTopicView
        Decoders.addDecoder(clazz: FeedResponseTopicView.self) { (source: AnyObject) -> FeedResponseTopicView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = FeedResponseTopicView()
            instance.data = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["data"] as AnyObject?)
            instance.cursor = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cursor"] as AnyObject?)
            return instance
        }


        // Decoder for [FeedResponseUserCompactView]
        Decoders.addDecoder(clazz: [FeedResponseUserCompactView].self) { (source: AnyObject) -> [FeedResponseUserCompactView] in
            return Decoders.decode(clazz: [FeedResponseUserCompactView].self, source: source)
        }
        // Decoder for FeedResponseUserCompactView
        Decoders.addDecoder(clazz: FeedResponseUserCompactView.self) { (source: AnyObject) -> FeedResponseUserCompactView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = FeedResponseUserCompactView()
            instance.data = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["data"] as AnyObject?)
            instance.cursor = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cursor"] as AnyObject?)
            return instance
        }


        // Decoder for [FeedResponseUserProfileView]
        Decoders.addDecoder(clazz: [FeedResponseUserProfileView].self) { (source: AnyObject) -> [FeedResponseUserProfileView] in
            return Decoders.decode(clazz: [FeedResponseUserProfileView].self, source: source)
        }
        // Decoder for FeedResponseUserProfileView
        Decoders.addDecoder(clazz: FeedResponseUserProfileView.self) { (source: AnyObject) -> FeedResponseUserProfileView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = FeedResponseUserProfileView()
            instance.data = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["data"] as AnyObject?)
            instance.cursor = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cursor"] as AnyObject?)
            return instance
        }


        // Decoder for [GetRequestTokenResponse]
        Decoders.addDecoder(clazz: [GetRequestTokenResponse].self) { (source: AnyObject) -> [GetRequestTokenResponse] in
            return Decoders.decode(clazz: [GetRequestTokenResponse].self, source: source)
        }
        // Decoder for GetRequestTokenResponse
        Decoders.addDecoder(clazz: GetRequestTokenResponse.self) { (source: AnyObject) -> GetRequestTokenResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = GetRequestTokenResponse()
            instance.requestToken = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["requestToken"] as AnyObject?)
            return instance
        }


        // Decoder for [GetTopicNameResponse]
        Decoders.addDecoder(clazz: [GetTopicNameResponse].self) { (source: AnyObject) -> [GetTopicNameResponse] in
            return Decoders.decode(clazz: [GetTopicNameResponse].self, source: source)
        }
        // Decoder for GetTopicNameResponse
        Decoders.addDecoder(clazz: GetTopicNameResponse.self) { (source: AnyObject) -> GetTopicNameResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = GetTopicNameResponse()
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [LinkedAccountView]
        Decoders.addDecoder(clazz: [LinkedAccountView].self) { (source: AnyObject) -> [LinkedAccountView] in
            return Decoders.decode(clazz: [LinkedAccountView].self, source: source)
        }
        // Decoder for LinkedAccountView
        Decoders.addDecoder(clazz: LinkedAccountView.self) { (source: AnyObject) -> LinkedAccountView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = LinkedAccountView()
            if let identityProvider = sourceDictionary["identityProvider"] as? String { 
                instance.identityProvider = LinkedAccountView.IdentityProvider(rawValue: (identityProvider))
            }
            
            instance.accountId = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["accountId"] as AnyObject?)
            return instance
        }


        // Decoder for [Object]
        Decoders.addDecoder(clazz: [Object].self) { (source: AnyObject) -> [Object] in
            return Decoders.decode(clazz: [Object].self, source: source)
        }
        // Decoder for Object
        Decoders.addDecoder(clazz: Object.self) { (source: AnyObject) -> Object in
            if let source = source as? Any {
                return source
            }
            fatalError("Source \(source) is not convertible to typealias Object: Maybe swagger file is insufficient")
        }


        // Decoder for [PostBlobResponse]
        Decoders.addDecoder(clazz: [PostBlobResponse].self) { (source: AnyObject) -> [PostBlobResponse] in
            return Decoders.decode(clazz: [PostBlobResponse].self, source: source)
        }
        // Decoder for PostBlobResponse
        Decoders.addDecoder(clazz: PostBlobResponse.self) { (source: AnyObject) -> PostBlobResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostBlobResponse()
            instance.blobHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostBlockedUserRequest]
        Decoders.addDecoder(clazz: [PostBlockedUserRequest].self) { (source: AnyObject) -> [PostBlockedUserRequest] in
            return Decoders.decode(clazz: [PostBlockedUserRequest].self, source: source)
        }
        // Decoder for PostBlockedUserRequest
        Decoders.addDecoder(clazz: PostBlockedUserRequest.self) { (source: AnyObject) -> PostBlockedUserRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostBlockedUserRequest()
            instance.userHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostCommentRequest]
        Decoders.addDecoder(clazz: [PostCommentRequest].self) { (source: AnyObject) -> [PostCommentRequest] in
            return Decoders.decode(clazz: [PostCommentRequest].self, source: source)
        }
        // Decoder for PostCommentRequest
        Decoders.addDecoder(clazz: PostCommentRequest.self) { (source: AnyObject) -> PostCommentRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostCommentRequest()
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            if let blobType = sourceDictionary["blobType"] as? String { 
                instance.blobType = PostCommentRequest.BlobType(rawValue: (blobType))
            }
            
            instance.blobHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobHandle"] as AnyObject?)
            instance.language = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["language"] as AnyObject?)
            return instance
        }


        // Decoder for [PostCommentResponse]
        Decoders.addDecoder(clazz: [PostCommentResponse].self) { (source: AnyObject) -> [PostCommentResponse] in
            return Decoders.decode(clazz: [PostCommentResponse].self, source: source)
        }
        // Decoder for PostCommentResponse
        Decoders.addDecoder(clazz: PostCommentResponse.self) { (source: AnyObject) -> PostCommentResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostCommentResponse()
            instance.commentHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["commentHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostFollowerRequest]
        Decoders.addDecoder(clazz: [PostFollowerRequest].self) { (source: AnyObject) -> [PostFollowerRequest] in
            return Decoders.decode(clazz: [PostFollowerRequest].self, source: source)
        }
        // Decoder for PostFollowerRequest
        Decoders.addDecoder(clazz: PostFollowerRequest.self) { (source: AnyObject) -> PostFollowerRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostFollowerRequest()
            instance.userHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostFollowingTopicRequest]
        Decoders.addDecoder(clazz: [PostFollowingTopicRequest].self) { (source: AnyObject) -> [PostFollowingTopicRequest] in
            return Decoders.decode(clazz: [PostFollowingTopicRequest].self, source: source)
        }
        // Decoder for PostFollowingTopicRequest
        Decoders.addDecoder(clazz: PostFollowingTopicRequest.self) { (source: AnyObject) -> PostFollowingTopicRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostFollowingTopicRequest()
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostFollowingUserRequest]
        Decoders.addDecoder(clazz: [PostFollowingUserRequest].self) { (source: AnyObject) -> [PostFollowingUserRequest] in
            return Decoders.decode(clazz: [PostFollowingUserRequest].self, source: source)
        }
        // Decoder for PostFollowingUserRequest
        Decoders.addDecoder(clazz: PostFollowingUserRequest.self) { (source: AnyObject) -> PostFollowingUserRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostFollowingUserRequest()
            instance.userHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostImageResponse]
        Decoders.addDecoder(clazz: [PostImageResponse].self) { (source: AnyObject) -> [PostImageResponse] in
            return Decoders.decode(clazz: [PostImageResponse].self, source: source)
        }
        // Decoder for PostImageResponse
        Decoders.addDecoder(clazz: PostImageResponse.self) { (source: AnyObject) -> PostImageResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostImageResponse()
            instance.blobHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostLinkedAccountRequest]
        Decoders.addDecoder(clazz: [PostLinkedAccountRequest].self) { (source: AnyObject) -> [PostLinkedAccountRequest] in
            return Decoders.decode(clazz: [PostLinkedAccountRequest].self, source: source)
        }
        // Decoder for PostLinkedAccountRequest
        Decoders.addDecoder(clazz: PostLinkedAccountRequest.self) { (source: AnyObject) -> PostLinkedAccountRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostLinkedAccountRequest()
            instance.sessionToken = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sessionToken"] as AnyObject?)
            return instance
        }


        // Decoder for [PostPinRequest]
        Decoders.addDecoder(clazz: [PostPinRequest].self) { (source: AnyObject) -> [PostPinRequest] in
            return Decoders.decode(clazz: [PostPinRequest].self, source: source)
        }
        // Decoder for PostPinRequest
        Decoders.addDecoder(clazz: PostPinRequest.self) { (source: AnyObject) -> PostPinRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostPinRequest()
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostReplyRequest]
        Decoders.addDecoder(clazz: [PostReplyRequest].self) { (source: AnyObject) -> [PostReplyRequest] in
            return Decoders.decode(clazz: [PostReplyRequest].self, source: source)
        }
        // Decoder for PostReplyRequest
        Decoders.addDecoder(clazz: PostReplyRequest.self) { (source: AnyObject) -> PostReplyRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostReplyRequest()
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            instance.language = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["language"] as AnyObject?)
            return instance
        }


        // Decoder for [PostReplyResponse]
        Decoders.addDecoder(clazz: [PostReplyResponse].self) { (source: AnyObject) -> [PostReplyResponse] in
            return Decoders.decode(clazz: [PostReplyResponse].self, source: source)
        }
        // Decoder for PostReplyResponse
        Decoders.addDecoder(clazz: PostReplyResponse.self) { (source: AnyObject) -> PostReplyResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostReplyResponse()
            instance.replyHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["replyHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostReportRequest]
        Decoders.addDecoder(clazz: [PostReportRequest].self) { (source: AnyObject) -> [PostReportRequest] in
            return Decoders.decode(clazz: [PostReportRequest].self, source: source)
        }
        // Decoder for PostReportRequest
        Decoders.addDecoder(clazz: PostReportRequest.self) { (source: AnyObject) -> PostReportRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostReportRequest()
            if let reason = sourceDictionary["reason"] as? String { 
                instance.reason = PostReportRequest.Reason(rawValue: (reason))
            }
            
            return instance
        }


        // Decoder for [PostSessionRequest]
        Decoders.addDecoder(clazz: [PostSessionRequest].self) { (source: AnyObject) -> [PostSessionRequest] in
            return Decoders.decode(clazz: [PostSessionRequest].self, source: source)
        }
        // Decoder for PostSessionRequest
        Decoders.addDecoder(clazz: PostSessionRequest.self) { (source: AnyObject) -> PostSessionRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostSessionRequest()
            instance.instanceId = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceId"] as AnyObject?)
            instance.userHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostSessionResponse]
        Decoders.addDecoder(clazz: [PostSessionResponse].self) { (source: AnyObject) -> [PostSessionResponse] in
            return Decoders.decode(clazz: [PostSessionResponse].self, source: source)
        }
        // Decoder for PostSessionResponse
        Decoders.addDecoder(clazz: PostSessionResponse.self) { (source: AnyObject) -> PostSessionResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostSessionResponse()
            instance.userHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userHandle"] as AnyObject?)
            instance.sessionToken = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sessionToken"] as AnyObject?)
            return instance
        }


        // Decoder for [PostTopicNameRequest]
        Decoders.addDecoder(clazz: [PostTopicNameRequest].self) { (source: AnyObject) -> [PostTopicNameRequest] in
            return Decoders.decode(clazz: [PostTopicNameRequest].self, source: source)
        }
        // Decoder for PostTopicNameRequest
        Decoders.addDecoder(clazz: PostTopicNameRequest.self) { (source: AnyObject) -> PostTopicNameRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostTopicNameRequest()
            if let publisherType = sourceDictionary["publisherType"] as? String { 
                instance.publisherType = PostTopicNameRequest.PublisherType(rawValue: (publisherType))
            }
            
            instance.topicName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicName"] as AnyObject?)
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostTopicRequest]
        Decoders.addDecoder(clazz: [PostTopicRequest].self) { (source: AnyObject) -> [PostTopicRequest] in
            return Decoders.decode(clazz: [PostTopicRequest].self, source: source)
        }
        // Decoder for PostTopicRequest
        Decoders.addDecoder(clazz: PostTopicRequest.self) { (source: AnyObject) -> PostTopicRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostTopicRequest()
            if let publisherType = sourceDictionary["publisherType"] as? String { 
                instance.publisherType = PostTopicRequest.PublisherType(rawValue: (publisherType))
            }
            
            instance.title = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["title"] as AnyObject?)
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            if let blobType = sourceDictionary["blobType"] as? String { 
                instance.blobType = PostTopicRequest.BlobType(rawValue: (blobType))
            }
            
            instance.blobHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobHandle"] as AnyObject?)
            instance.categories = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["categories"] as AnyObject?)
            instance.language = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["language"] as AnyObject?)
            instance.deepLink = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deepLink"] as AnyObject?)
            instance.friendlyName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["friendlyName"] as AnyObject?)
            instance.group = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["group"] as AnyObject?)
            return instance
        }


        // Decoder for [PostTopicResponse]
        Decoders.addDecoder(clazz: [PostTopicResponse].self) { (source: AnyObject) -> [PostTopicResponse] in
            return Decoders.decode(clazz: [PostTopicResponse].self, source: source)
        }
        // Decoder for PostTopicResponse
        Decoders.addDecoder(clazz: PostTopicResponse.self) { (source: AnyObject) -> PostTopicResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostTopicResponse()
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostUserRequest]
        Decoders.addDecoder(clazz: [PostUserRequest].self) { (source: AnyObject) -> [PostUserRequest] in
            return Decoders.decode(clazz: [PostUserRequest].self, source: source)
        }
        // Decoder for PostUserRequest
        Decoders.addDecoder(clazz: PostUserRequest.self) { (source: AnyObject) -> PostUserRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostUserRequest()
            instance.instanceId = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceId"] as AnyObject?)
            instance.firstName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["firstName"] as AnyObject?)
            instance.lastName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"] as AnyObject?)
            instance.bio = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bio"] as AnyObject?)
            instance.photoHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PostUserResponse]
        Decoders.addDecoder(clazz: [PostUserResponse].self) { (source: AnyObject) -> [PostUserResponse] in
            return Decoders.decode(clazz: [PostUserResponse].self, source: source)
        }
        // Decoder for PostUserResponse
        Decoders.addDecoder(clazz: PostUserResponse.self) { (source: AnyObject) -> PostUserResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PostUserResponse()
            instance.userHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userHandle"] as AnyObject?)
            instance.sessionToken = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sessionToken"] as AnyObject?)
            return instance
        }


        // Decoder for [PutNotificationsStatusRequest]
        Decoders.addDecoder(clazz: [PutNotificationsStatusRequest].self) { (source: AnyObject) -> [PutNotificationsStatusRequest] in
            return Decoders.decode(clazz: [PutNotificationsStatusRequest].self, source: source)
        }
        // Decoder for PutNotificationsStatusRequest
        Decoders.addDecoder(clazz: PutNotificationsStatusRequest.self) { (source: AnyObject) -> PutNotificationsStatusRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PutNotificationsStatusRequest()
            instance.readActivityHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["readActivityHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PutPushRegistrationRequest]
        Decoders.addDecoder(clazz: [PutPushRegistrationRequest].self) { (source: AnyObject) -> [PutPushRegistrationRequest] in
            return Decoders.decode(clazz: [PutPushRegistrationRequest].self, source: source)
        }
        // Decoder for PutPushRegistrationRequest
        Decoders.addDecoder(clazz: PutPushRegistrationRequest.self) { (source: AnyObject) -> PutPushRegistrationRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PutPushRegistrationRequest()
            instance.lastUpdatedTime = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastUpdatedTime"] as AnyObject?)
            instance.language = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["language"] as AnyObject?)
            return instance
        }


        // Decoder for [PutTopicNameRequest]
        Decoders.addDecoder(clazz: [PutTopicNameRequest].self) { (source: AnyObject) -> [PutTopicNameRequest] in
            return Decoders.decode(clazz: [PutTopicNameRequest].self, source: source)
        }
        // Decoder for PutTopicNameRequest
        Decoders.addDecoder(clazz: PutTopicNameRequest.self) { (source: AnyObject) -> PutTopicNameRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PutTopicNameRequest()
            if let publisherType = sourceDictionary["publisherType"] as? String { 
                instance.publisherType = PutTopicNameRequest.PublisherType(rawValue: (publisherType))
            }
            
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PutTopicRequest]
        Decoders.addDecoder(clazz: [PutTopicRequest].self) { (source: AnyObject) -> [PutTopicRequest] in
            return Decoders.decode(clazz: [PutTopicRequest].self, source: source)
        }
        // Decoder for PutTopicRequest
        Decoders.addDecoder(clazz: PutTopicRequest.self) { (source: AnyObject) -> PutTopicRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PutTopicRequest()
            instance.title = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["title"] as AnyObject?)
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            instance.categories = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["categories"] as AnyObject?)
            return instance
        }


        // Decoder for [PutUserInfoRequest]
        Decoders.addDecoder(clazz: [PutUserInfoRequest].self) { (source: AnyObject) -> [PutUserInfoRequest] in
            return Decoders.decode(clazz: [PutUserInfoRequest].self, source: source)
        }
        // Decoder for PutUserInfoRequest
        Decoders.addDecoder(clazz: PutUserInfoRequest.self) { (source: AnyObject) -> PutUserInfoRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PutUserInfoRequest()
            instance.firstName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["firstName"] as AnyObject?)
            instance.lastName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"] as AnyObject?)
            instance.bio = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bio"] as AnyObject?)
            return instance
        }


        // Decoder for [PutUserPhotoRequest]
        Decoders.addDecoder(clazz: [PutUserPhotoRequest].self) { (source: AnyObject) -> [PutUserPhotoRequest] in
            return Decoders.decode(clazz: [PutUserPhotoRequest].self, source: source)
        }
        // Decoder for PutUserPhotoRequest
        Decoders.addDecoder(clazz: PutUserPhotoRequest.self) { (source: AnyObject) -> PutUserPhotoRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PutUserPhotoRequest()
            instance.photoHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoHandle"] as AnyObject?)
            return instance
        }


        // Decoder for [PutUserVisibilityRequest]
        Decoders.addDecoder(clazz: [PutUserVisibilityRequest].self) { (source: AnyObject) -> [PutUserVisibilityRequest] in
            return Decoders.decode(clazz: [PutUserVisibilityRequest].self, source: source)
        }
        // Decoder for PutUserVisibilityRequest
        Decoders.addDecoder(clazz: PutUserVisibilityRequest.self) { (source: AnyObject) -> PutUserVisibilityRequest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = PutUserVisibilityRequest()
            if let visibility = sourceDictionary["visibility"] as? String { 
                instance.visibility = PutUserVisibilityRequest.Visibility(rawValue: (visibility))
            }
            
            return instance
        }


        // Decoder for [ReplyView]
        Decoders.addDecoder(clazz: [ReplyView].self) { (source: AnyObject) -> [ReplyView] in
            return Decoders.decode(clazz: [ReplyView].self, source: source)
        }
        // Decoder for ReplyView
        Decoders.addDecoder(clazz: ReplyView.self) { (source: AnyObject) -> ReplyView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ReplyView()
            instance.replyHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["replyHandle"] as AnyObject?)
            instance.commentHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["commentHandle"] as AnyObject?)
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            instance.createdTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["createdTime"] as AnyObject?)
            instance.lastUpdatedTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["lastUpdatedTime"] as AnyObject?)
            instance.user = Decoders.decodeOptional(clazz: UserCompactView.self, source: sourceDictionary["user"] as AnyObject?)
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            instance.language = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["language"] as AnyObject?)
            instance.totalLikes = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["totalLikes"] as AnyObject?)
            instance.liked = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["liked"] as AnyObject?)
            if let contentStatus = sourceDictionary["contentStatus"] as? String { 
                instance.contentStatus = ReplyView.ContentStatus(rawValue: (contentStatus))
            }
            
            return instance
        }


        // Decoder for [TopicView]
        Decoders.addDecoder(clazz: [TopicView].self) { (source: AnyObject) -> [TopicView] in
            return Decoders.decode(clazz: [TopicView].self, source: source)
        }
        // Decoder for TopicView
        Decoders.addDecoder(clazz: TopicView.self) { (source: AnyObject) -> TopicView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = TopicView()
            instance.topicHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topicHandle"] as AnyObject?)
            instance.createdTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["createdTime"] as AnyObject?)
            instance.lastUpdatedTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["lastUpdatedTime"] as AnyObject?)
            if let publisherType = sourceDictionary["publisherType"] as? String { 
                instance.publisherType = TopicView.PublisherType(rawValue: (publisherType))
            }
            
            instance.user = Decoders.decodeOptional(clazz: UserCompactView.self, source: sourceDictionary["user"] as AnyObject?)
            instance.title = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["title"] as AnyObject?)
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            if let blobType = sourceDictionary["blobType"] as? String { 
                instance.blobType = TopicView.BlobType(rawValue: (blobType))
            }
            
            instance.blobHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobHandle"] as AnyObject?)
            instance.blobUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["blobUrl"] as AnyObject?)
            instance.categories = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["categories"] as AnyObject?)
            instance.language = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["language"] as AnyObject?)
            instance.group = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["group"] as AnyObject?)
            instance.deepLink = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deepLink"] as AnyObject?)
            instance.friendlyName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["friendlyName"] as AnyObject?)
            instance.totalLikes = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["totalLikes"] as AnyObject?)
            instance.totalComments = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["totalComments"] as AnyObject?)
            instance.liked = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["liked"] as AnyObject?)
            instance.pinned = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["pinned"] as AnyObject?)
            if let contentStatus = sourceDictionary["contentStatus"] as? String { 
                instance.contentStatus = TopicView.ContentStatus(rawValue: (contentStatus))
            }
            
            instance.app = Decoders.decodeOptional(clazz: AppCompactView.self, source: sourceDictionary["app"] as AnyObject?)
            return instance
        }


        // Decoder for [UserCompactView]
        Decoders.addDecoder(clazz: [UserCompactView].self) { (source: AnyObject) -> [UserCompactView] in
            return Decoders.decode(clazz: [UserCompactView].self, source: source)
        }
        // Decoder for UserCompactView
        Decoders.addDecoder(clazz: UserCompactView.self) { (source: AnyObject) -> UserCompactView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = UserCompactView()
            instance.userHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userHandle"] as AnyObject?)
            instance.firstName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["firstName"] as AnyObject?)
            instance.lastName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"] as AnyObject?)
            instance.photoHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoHandle"] as AnyObject?)
            instance.photoUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoUrl"] as AnyObject?)
            if let visibility = sourceDictionary["visibility"] as? String { 
                instance.visibility = UserCompactView.Visibility(rawValue: (visibility))
            }
            
            if let followerStatus = sourceDictionary["followerStatus"] as? String { 
                instance.followerStatus = UserCompactView.FollowerStatus(rawValue: (followerStatus))
            }
            
            return instance
        }


        // Decoder for [UserProfileView]
        Decoders.addDecoder(clazz: [UserProfileView].self) { (source: AnyObject) -> [UserProfileView] in
            return Decoders.decode(clazz: [UserProfileView].self, source: source)
        }
        // Decoder for UserProfileView
        Decoders.addDecoder(clazz: UserProfileView.self) { (source: AnyObject) -> UserProfileView in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = UserProfileView()
            instance.userHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userHandle"] as AnyObject?)
            instance.firstName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["firstName"] as AnyObject?)
            instance.lastName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"] as AnyObject?)
            instance.bio = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bio"] as AnyObject?)
            instance.photoHandle = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoHandle"] as AnyObject?)
            instance.photoUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoUrl"] as AnyObject?)
            if let visibility = sourceDictionary["visibility"] as? String { 
                instance.visibility = UserProfileView.Visibility(rawValue: (visibility))
            }
            
            instance.totalTopics = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["totalTopics"] as AnyObject?)
            instance.totalFollowers = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["totalFollowers"] as AnyObject?)
            instance.totalFollowing = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["totalFollowing"] as AnyObject?)
            if let followerStatus = sourceDictionary["followerStatus"] as? String { 
                instance.followerStatus = UserProfileView.FollowerStatus(rawValue: (followerStatus))
            }
            
            if let followingStatus = sourceDictionary["followingStatus"] as? String { 
                instance.followingStatus = UserProfileView.FollowingStatus(rawValue: (followingStatus))
            }
            
            if let profileStatus = sourceDictionary["profileStatus"] as? String { 
                instance.profileStatus = UserProfileView.ProfileStatus(rawValue: (profileStatus))
            }
            
            return instance
        }
    }()

    static fileprivate func initialize() {
        _ = Decoders.__once
    }
}
