//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class LikesAPI: APIBase {
    /**
     Remove like from comment
     
     - parameter commentHandle: (path) Comment handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func commentLikesDeleteLike(commentHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        commentLikesDeleteLikeWithRequestBuilder(commentHandle: commentHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Remove like from comment
     - DELETE /v0.6/comments/{commentHandle}/likes/me
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter commentHandle: (path) Comment handle 

     - returns: RequestBuilder<Object> 
     */
    open class func commentLikesDeleteLikeWithRequestBuilder(commentHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/comments/{commentHandle}/likes/me"
        path = path.replacingOccurrences(of: "{commentHandle}", with: "\(commentHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get likes for comment
     
     - parameter commentHandle: (path) Comment handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func commentLikesGetLikes(commentHandle: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        commentLikesGetLikesWithRequestBuilder(commentHandle: commentHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get likes for comment
     - GET /v0.6/comments/{commentHandle}/likes
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter commentHandle: (path) Comment handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func commentLikesGetLikesWithRequestBuilder(commentHandle: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        var path = "/v0.6/comments/{commentHandle}/likes"
        path = path.replacingOccurrences(of: "{commentHandle}", with: "\(commentHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor,
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseUserCompactView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Add like to comment
     
     - parameter commentHandle: (path) Comment handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func commentLikesPostLike(commentHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        commentLikesPostLikeWithRequestBuilder(commentHandle: commentHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Add like to comment
     - POST /v0.6/comments/{commentHandle}/likes
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter commentHandle: (path) Comment handle 

     - returns: RequestBuilder<Object> 
     */
    open class func commentLikesPostLikeWithRequestBuilder(commentHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/comments/{commentHandle}/likes"
        path = path.replacingOccurrences(of: "{commentHandle}", with: "\(commentHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Remove like from reply
     
     - parameter replyHandle: (path) Reply handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func replyLikesDeleteLike(replyHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        replyLikesDeleteLikeWithRequestBuilder(replyHandle: replyHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Remove like from reply
     - DELETE /v0.6/replies/{replyHandle}/likes/me
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter replyHandle: (path) Reply handle 

     - returns: RequestBuilder<Object> 
     */
    open class func replyLikesDeleteLikeWithRequestBuilder(replyHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/replies/{replyHandle}/likes/me"
        path = path.replacingOccurrences(of: "{replyHandle}", with: "\(replyHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get likes for reply
     
     - parameter replyHandle: (path) Reply handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func replyLikesGetLikes(replyHandle: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        replyLikesGetLikesWithRequestBuilder(replyHandle: replyHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get likes for reply
     - GET /v0.6/replies/{replyHandle}/likes
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter replyHandle: (path) Reply handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func replyLikesGetLikesWithRequestBuilder(replyHandle: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        var path = "/v0.6/replies/{replyHandle}/likes"
        path = path.replacingOccurrences(of: "{replyHandle}", with: "\(replyHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor,
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseUserCompactView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Add like to reply
     
     - parameter replyHandle: (path) Reply handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func replyLikesPostLike(replyHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        replyLikesPostLikeWithRequestBuilder(replyHandle: replyHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Add like to reply
     - POST /v0.6/replies/{replyHandle}/likes
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter replyHandle: (path) Reply handle 

     - returns: RequestBuilder<Object> 
     */
    open class func replyLikesPostLikeWithRequestBuilder(replyHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/replies/{replyHandle}/likes"
        path = path.replacingOccurrences(of: "{replyHandle}", with: "\(replyHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Remove like from topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicLikesDeleteLike(topicHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        topicLikesDeleteLikeWithRequestBuilder(topicHandle: topicHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Remove like from topic
     - DELETE /v0.6/topics/{topicHandle}/likes/me
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 

     - returns: RequestBuilder<Object> 
     */
    open class func topicLikesDeleteLikeWithRequestBuilder(topicHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/topics/{topicHandle}/likes/me"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get likes for topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicLikesGetLikes(topicHandle: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        topicLikesGetLikesWithRequestBuilder(topicHandle: topicHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get likes for topic
     - GET /v0.6/topics/{topicHandle}/likes
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "userHandle" : "aeiou",
    "firstName" : "aeiou",
    "lastName" : "aeiou",
    "photoUrl" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "photoHandle" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func topicLikesGetLikesWithRequestBuilder(topicHandle: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        var path = "/v0.6/topics/{topicHandle}/likes"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor,
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseUserCompactView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Add like to topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicLikesPostLike(topicHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        topicLikesPostLikeWithRequestBuilder(topicHandle: topicHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Add like to topic
     - POST /v0.6/topics/{topicHandle}/likes
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 

     - returns: RequestBuilder<Object> 
     */
    open class func topicLikesPostLikeWithRequestBuilder(topicHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/topics/{topicHandle}/likes"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
