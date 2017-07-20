//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class RepliesAPI: APIBase {
    /**
     Get replies for a comment
     
     - parameter commentHandle: (path) Comment handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func commentRepliesGetReplies(commentHandle: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseReplyView?,_ error: Error?) -> Void)) {
        commentRepliesGetRepliesWithRequestBuilder(commentHandle: commentHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get replies for a comment
     - GET /v0.6/comments/{commentHandle}/replies
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "topicHandle" : "aeiou",
    "commentHandle" : "aeiou",
    "replyHandle" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
    "language" : "aeiou",
    "text" : "aeiou",
    "totalLikes" : 123456789,
    "user" : {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "aeiou",
      "visibility" : "aeiou",
      "photoHandle" : "aeiou"
    },
    "liked" : true,
    "contentStatus" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "topicHandle" : "aeiou",
    "commentHandle" : "aeiou",
    "replyHandle" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
    "language" : "aeiou",
    "text" : "aeiou",
    "totalLikes" : 123456789,
    "user" : {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "aeiou",
      "visibility" : "aeiou",
      "photoHandle" : "aeiou"
    },
    "liked" : true,
    "contentStatus" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter commentHandle: (path) Comment handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseReplyView> 
     */
    open class func commentRepliesGetRepliesWithRequestBuilder(commentHandle: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseReplyView> {
        var path = "/v0.6/comments/{commentHandle}/replies"
        path = path.replacingOccurrences(of: "{commentHandle}", with: "\(commentHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor,
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseReplyView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Create a new reply
     
     - parameter commentHandle: (path) Comment handle 
     - parameter request: (body) Post reply request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func commentRepliesPostReply(commentHandle: String, request: PostReplyRequest, completion: @escaping ((_ data: PostReplyResponse?,_ error: Error?) -> Void)) {
        commentRepliesPostReplyWithRequestBuilder(commentHandle: commentHandle, request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Create a new reply
     - POST /v0.6/comments/{commentHandle}/replies
     - examples: [{contentType=application/json, example={
  "replyHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <replyHandle>string</replyHandle>
</null>}]
     - examples: [{contentType=application/json, example={
  "replyHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <replyHandle>string</replyHandle>
</null>}]
     
     - parameter commentHandle: (path) Comment handle 
     - parameter request: (body) Post reply request 

     - returns: RequestBuilder<PostReplyResponse> 
     */
    open class func commentRepliesPostReplyWithRequestBuilder(commentHandle: String, request: PostReplyRequest) -> RequestBuilder<PostReplyResponse> {
        var path = "/v0.6/comments/{commentHandle}/replies"
        path = path.replacingOccurrences(of: "{commentHandle}", with: "\(commentHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<PostReplyResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Delete reply
     
     - parameter replyHandle: (path) Reply handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func repliesDeleteReply(replyHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        repliesDeleteReplyWithRequestBuilder(replyHandle: replyHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Delete reply
     - DELETE /v0.6/replies/{replyHandle}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter replyHandle: (path) Reply handle 

     - returns: RequestBuilder<Object> 
     */
    open class func repliesDeleteReplyWithRequestBuilder(replyHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/replies/{replyHandle}"
        path = path.replacingOccurrences(of: "{replyHandle}", with: "\(replyHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get reply
     
     - parameter replyHandle: (path) Reply handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func repliesGetReply(replyHandle: String, completion: @escaping ((_ data: ReplyView?,_ error: Error?) -> Void)) {
        repliesGetReplyWithRequestBuilder(replyHandle: replyHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get reply
     - GET /v0.6/replies/{replyHandle}
     - examples: [{contentType=application/json, example={
  "topicHandle" : "aeiou",
  "commentHandle" : "aeiou",
  "replyHandle" : "aeiou",
  "createdTime" : "2000-01-23T04:56:07.000+00:00",
  "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
  "language" : "aeiou",
  "text" : "aeiou",
  "totalLikes" : 123456789,
  "user" : {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  },
  "liked" : true,
  "contentStatus" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <replyHandle>string</replyHandle>
  <commentHandle>string</commentHandle>
  <topicHandle>string</topicHandle>
  <createdTime>2000-01-23T04:56:07.000Z</createdTime>
  <lastUpdatedTime>2000-01-23T04:56:07.000Z</lastUpdatedTime>
  <text>string</text>
  <language>string</language>
  <totalLikes>123456</totalLikes>
  <liked>true</liked>
  <contentStatus>string</contentStatus>
</null>}]
     - examples: [{contentType=application/json, example={
  "topicHandle" : "aeiou",
  "commentHandle" : "aeiou",
  "replyHandle" : "aeiou",
  "createdTime" : "2000-01-23T04:56:07.000+00:00",
  "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
  "language" : "aeiou",
  "text" : "aeiou",
  "totalLikes" : 123456789,
  "user" : {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  },
  "liked" : true,
  "contentStatus" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <replyHandle>string</replyHandle>
  <commentHandle>string</commentHandle>
  <topicHandle>string</topicHandle>
  <createdTime>2000-01-23T04:56:07.000Z</createdTime>
  <lastUpdatedTime>2000-01-23T04:56:07.000Z</lastUpdatedTime>
  <text>string</text>
  <language>string</language>
  <totalLikes>123456</totalLikes>
  <liked>true</liked>
  <contentStatus>string</contentStatus>
</null>}]
     
     - parameter replyHandle: (path) Reply handle 

     - returns: RequestBuilder<ReplyView> 
     */
    open class func repliesGetReplyWithRequestBuilder(replyHandle: String) -> RequestBuilder<ReplyView> {
        var path = "/v0.6/replies/{replyHandle}"
        path = path.replacingOccurrences(of: "{replyHandle}", with: "\(replyHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<ReplyView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
