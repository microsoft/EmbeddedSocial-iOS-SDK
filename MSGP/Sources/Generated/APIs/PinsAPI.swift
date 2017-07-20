//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class PinsAPI: APIBase {
    /**
     Unpin a topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPinsDeletePin(topicHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myPinsDeletePinWithRequestBuilder(topicHandle: topicHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Unpin a topic
     - DELETE /v0.6/users/me/pins/{topicHandle}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 

     - returns: RequestBuilder<Object> 
     */
    open class func myPinsDeletePinWithRequestBuilder(topicHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/pins/{topicHandle}"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get my pins
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPinsGetPins(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        myPinsGetPinsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my pins
     - GET /v0.6/users/me/pins
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "app" : {
      "deepLink" : "aeiou",
      "name" : "aeiou",
      "platformType" : "aeiou",
      "iconUrl" : "aeiou",
      "iconHandle" : "aeiou",
      "storeLink" : "aeiou"
    },
    "topicHandle" : "aeiou",
    "publisherType" : "aeiou",
    "pinned" : true,
    "blobUrl" : "aeiou",
    "language" : "aeiou",
    "title" : "aeiou",
    "blobHandle" : "aeiou",
    "liked" : true,
    "contentStatus" : "aeiou",
    "totalComments" : 123456789,
    "deepLink" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
    "text" : "aeiou",
    "categories" : "aeiou",
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
    },
    "friendlyName" : "aeiou",
    "group" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "app" : {
      "deepLink" : "aeiou",
      "name" : "aeiou",
      "platformType" : "aeiou",
      "iconUrl" : "aeiou",
      "iconHandle" : "aeiou",
      "storeLink" : "aeiou"
    },
    "topicHandle" : "aeiou",
    "publisherType" : "aeiou",
    "pinned" : true,
    "blobUrl" : "aeiou",
    "language" : "aeiou",
    "title" : "aeiou",
    "blobHandle" : "aeiou",
    "liked" : true,
    "contentStatus" : "aeiou",
    "totalComments" : 123456789,
    "deepLink" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
    "text" : "aeiou",
    "categories" : "aeiou",
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
    },
    "friendlyName" : "aeiou",
    "group" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseTopicView> 
     */
    open class func myPinsGetPinsWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/users/me/pins"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor,
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseTopicView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Pin a topic
     
     - parameter request: (body) Post pin request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPinsPostPin(request: PostPinRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myPinsPostPinWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Pin a topic
     - POST /v0.6/users/me/pins
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Post pin request 

     - returns: RequestBuilder<Object> 
     */
    open class func myPinsPostPinWithRequestBuilder(request: PostPinRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/pins"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
