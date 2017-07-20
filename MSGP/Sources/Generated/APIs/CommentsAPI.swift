//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class CommentsAPI: APIBase {
    /**
     Delete comment
     
     - parameter commentHandle: (path) Comment handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func commentsDeleteComment(commentHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        commentsDeleteCommentWithRequestBuilder(commentHandle: commentHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Delete comment
     - DELETE /v0.6/comments/{commentHandle}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter commentHandle: (path) Comment handle 

     - returns: RequestBuilder<Object> 
     */
    open class func commentsDeleteCommentWithRequestBuilder(commentHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/comments/{commentHandle}"
        path = path.replacingOccurrences(of: "{commentHandle}", with: "\(commentHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get comment
     
     - parameter commentHandle: (path) Comment handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func commentsGetComment(commentHandle: String, completion: @escaping ((_ data: CommentView?,_ error: Error?) -> Void)) {
        commentsGetCommentWithRequestBuilder(commentHandle: commentHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get comment
     - GET /v0.6/comments/{commentHandle}
     - examples: [{contentType=application/json, example={
  "topicHandle" : "aeiou",
  "blobUrl" : "aeiou",
  "language" : "aeiou",
  "blobHandle" : "aeiou",
  "liked" : true,
  "contentStatus" : "aeiou",
  "commentHandle" : "aeiou",
  "totalReplies" : 123456789,
  "createdTime" : "2000-01-23T04:56:07.000+00:00",
  "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
  "text" : "aeiou",
  "totalLikes" : 123456789,
  "blobType" : "aeiou",
  "user" : {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  }
}}, {contentType=application/xml, example=<null>
  <commentHandle>string</commentHandle>
  <topicHandle>string</topicHandle>
  <createdTime>2000-01-23T04:56:07.000Z</createdTime>
  <lastUpdatedTime>2000-01-23T04:56:07.000Z</lastUpdatedTime>
  <text>string</text>
  <blobType>string</blobType>
  <blobHandle>string</blobHandle>
  <blobUrl>string</blobUrl>
  <language>string</language>
  <totalLikes>123456</totalLikes>
  <totalReplies>123456</totalReplies>
  <liked>true</liked>
  <contentStatus>string</contentStatus>
</null>}]
     - examples: [{contentType=application/json, example={
  "topicHandle" : "aeiou",
  "blobUrl" : "aeiou",
  "language" : "aeiou",
  "blobHandle" : "aeiou",
  "liked" : true,
  "contentStatus" : "aeiou",
  "commentHandle" : "aeiou",
  "totalReplies" : 123456789,
  "createdTime" : "2000-01-23T04:56:07.000+00:00",
  "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
  "text" : "aeiou",
  "totalLikes" : 123456789,
  "blobType" : "aeiou",
  "user" : {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  }
}}, {contentType=application/xml, example=<null>
  <commentHandle>string</commentHandle>
  <topicHandle>string</topicHandle>
  <createdTime>2000-01-23T04:56:07.000Z</createdTime>
  <lastUpdatedTime>2000-01-23T04:56:07.000Z</lastUpdatedTime>
  <text>string</text>
  <blobType>string</blobType>
  <blobHandle>string</blobHandle>
  <blobUrl>string</blobUrl>
  <language>string</language>
  <totalLikes>123456</totalLikes>
  <totalReplies>123456</totalReplies>
  <liked>true</liked>
  <contentStatus>string</contentStatus>
</null>}]
     
     - parameter commentHandle: (path) Comment handle 

     - returns: RequestBuilder<CommentView> 
     */
    open class func commentsGetCommentWithRequestBuilder(commentHandle: String) -> RequestBuilder<CommentView> {
        var path = "/v0.6/comments/{commentHandle}"
        path = path.replacingOccurrences(of: "{commentHandle}", with: "\(commentHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<CommentView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get comments for a topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicCommentsGetTopicComments(topicHandle: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseCommentView?,_ error: Error?) -> Void)) {
        topicCommentsGetTopicCommentsWithRequestBuilder(topicHandle: topicHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get comments for a topic
     - GET /v0.6/topics/{topicHandle}/comments
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "topicHandle" : "aeiou",
    "blobUrl" : "aeiou",
    "language" : "aeiou",
    "blobHandle" : "aeiou",
    "liked" : true,
    "contentStatus" : "aeiou",
    "commentHandle" : "aeiou",
    "totalReplies" : 123456789,
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
    "text" : "aeiou",
    "totalLikes" : 123456789,
    "blobType" : "aeiou",
    "user" : {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "aeiou",
      "visibility" : "aeiou",
      "photoHandle" : "aeiou"
    }
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "topicHandle" : "aeiou",
    "blobUrl" : "aeiou",
    "language" : "aeiou",
    "blobHandle" : "aeiou",
    "liked" : true,
    "contentStatus" : "aeiou",
    "commentHandle" : "aeiou",
    "totalReplies" : 123456789,
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
    "text" : "aeiou",
    "totalLikes" : 123456789,
    "blobType" : "aeiou",
    "user" : {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "aeiou",
      "visibility" : "aeiou",
      "photoHandle" : "aeiou"
    }
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseCommentView> 
     */
    open class func topicCommentsGetTopicCommentsWithRequestBuilder(topicHandle: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseCommentView> {
        var path = "/v0.6/topics/{topicHandle}/comments"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor,
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseCommentView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Create a new comment
     
     - parameter topicHandle: (path) Topic handle 
     - parameter request: (body) Post comment request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicCommentsPostComment(topicHandle: String, request: PostCommentRequest, completion: @escaping ((_ data: PostCommentResponse?,_ error: Error?) -> Void)) {
        topicCommentsPostCommentWithRequestBuilder(topicHandle: topicHandle, request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Create a new comment
     - POST /v0.6/topics/{topicHandle}/comments
     - examples: [{contentType=application/json, example={
  "commentHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <commentHandle>string</commentHandle>
</null>}]
     - examples: [{contentType=application/json, example={
  "commentHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <commentHandle>string</commentHandle>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 
     - parameter request: (body) Post comment request 

     - returns: RequestBuilder<PostCommentResponse> 
     */
    open class func topicCommentsPostCommentWithRequestBuilder(topicHandle: String, request: PostCommentRequest) -> RequestBuilder<PostCommentResponse> {
        var path = "/v0.6/topics/{topicHandle}/comments"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<PostCommentResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
