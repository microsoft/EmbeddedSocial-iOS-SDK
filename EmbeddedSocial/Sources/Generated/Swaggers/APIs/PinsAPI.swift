//
// PinsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class PinsAPI: APIBase {
    /**
     Unpin a topic
     - parameter topicHandle: (path) Handle of pinned topic 
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPinsDeletePin(topicHandle: String, authorization: String, completion: @escaping ((_ data: Object?, _ error: ErrorResponse?) -> Void)) {
        myPinsDeletePinWithRequestBuilder(topicHandle: topicHandle, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Unpin a topic
     - DELETE /v0.7/users/me/pins/{topicHandle}

     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - parameter topicHandle: (path) Handle of pinned topic 
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken 
     - returns: RequestBuilder<Object> 
     */
    open class func myPinsDeletePinWithRequestBuilder(topicHandle: String, authorization: String) -> RequestBuilder<Object> {
        var path = "/v0.7/users/me/pins/{topicHandle}"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get my pins
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPinsGetPins(authorization: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?, _ error: ErrorResponse?) -> Void)) {
        myPinsGetPinsWithRequestBuilder(authorization: authorization, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get my pins
     - GET /v0.7/users/me/pins

     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "app" : {
      "deepLink" : "aeiou",
      "name" : "aeiou",
      "platformType" : "Windows",
      "iconUrl" : "aeiou",
      "iconHandle" : "aeiou",
      "storeLink" : "aeiou"
    },
    "topicHandle" : "aeiou",
    "publisherType" : "User",
    "pinned" : true,
    "blobUrl" : "aeiou",
    "language" : "aeiou",
    "title" : "aeiou",
    "blobHandle" : "aeiou",
    "liked" : true,
    "contentStatus" : "Active",
    "totalComments" : 6,
    "deepLink" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
    "text" : "aeiou",
    "categories" : "aeiou",
    "totalLikes" : 0,
    "blobType" : "Unknown",
    "user" : {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "None",
      "visibility" : "Public",
      "photoHandle" : "aeiou"
    },
    "friendlyName" : "aeiou",
    "group" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>aeiou</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "app" : {
      "deepLink" : "aeiou",
      "name" : "aeiou",
      "platformType" : "Windows",
      "iconUrl" : "aeiou",
      "iconHandle" : "aeiou",
      "storeLink" : "aeiou"
    },
    "topicHandle" : "aeiou",
    "publisherType" : "User",
    "pinned" : true,
    "blobUrl" : "aeiou",
    "language" : "aeiou",
    "title" : "aeiou",
    "blobHandle" : "aeiou",
    "liked" : true,
    "contentStatus" : "Active",
    "totalComments" : 6,
    "deepLink" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "lastUpdatedTime" : "2000-01-23T04:56:07.000+00:00",
    "text" : "aeiou",
    "categories" : "aeiou",
    "totalLikes" : 0,
    "blobType" : "Unknown",
    "user" : {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "None",
      "visibility" : "Public",
      "photoHandle" : "aeiou"
    },
    "friendlyName" : "aeiou",
    "group" : "aeiou"
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>aeiou</cursor>
</null>}]
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - returns: RequestBuilder<FeedResponseTopicView> 
     */
    open class func myPinsGetPinsWithRequestBuilder(authorization: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.7/users/me/pins"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "cursor": cursor, 
            "limit": limit?.encodeToJSON()
        ])
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<FeedResponseTopicView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Pin a topic
     - parameter request: (body) Post pin request 
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPinsPostPin(request: PostPinRequest, authorization: String, completion: @escaping ((_ data: Object?, _ error: ErrorResponse?) -> Void)) {
        myPinsPostPinWithRequestBuilder(request: request, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Pin a topic
     - POST /v0.7/users/me/pins

     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - parameter request: (body) Post pin request 
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken 
     - returns: RequestBuilder<Object> 
     */
    open class func myPinsPostPinWithRequestBuilder(request: PostPinRequest, authorization: String) -> RequestBuilder<Object> {
        let path = "/v0.7/users/me/pins"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

}