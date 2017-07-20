//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class TopicsAPI: APIBase {
    /**
     Delete topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsDeleteTopic(topicHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        topicsDeleteTopicWithRequestBuilder(topicHandle: topicHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Delete topic
     - DELETE /v0.6/topics/{topicHandle}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 

     - returns: RequestBuilder<Object> 
     */
    open class func topicsDeleteTopicWithRequestBuilder(topicHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/topics/{topicHandle}"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Delete a topic name
     
     - parameter topicName: (path) Topic name 
     - parameter request: (body) Delete topic request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsDeleteTopicName(topicName: String, request: DeleteTopicNameRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        topicsDeleteTopicNameWithRequestBuilder(topicName: topicName, request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Delete a topic name
     - DELETE /v0.6/topics/names/{topicName}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicName: (path) Topic name 
     - parameter request: (body) Delete topic request 

     - returns: RequestBuilder<Object> 
     */
    open class func topicsDeleteTopicNameWithRequestBuilder(topicName: String, request: DeleteTopicNameRequest) -> RequestBuilder<Object> {
        var path = "/v0.6/topics/names/{topicName}"
        path = path.replacingOccurrences(of: "{topicName}", with: "\(topicName)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get featured topics
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsGetFeaturedTopics(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        topicsGetFeaturedTopicsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get featured topics
     - GET /v0.6/topics/featured
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
    open class func topicsGetFeaturedTopicsWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/topics/featured"
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
     * enum for parameter timeRange
     */
    public enum TimeRange_topicsGetPopularTopics: String { 
        case today = "Today"
        case thisWeek = "ThisWeek"
        case thisMonth = "ThisMonth"
        case allTime = "AllTime"
    }

    /**
     Get popular topics today
     
     - parameter timeRange: (path) Time range 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsGetPopularTopics(timeRange: TimeRange_topicsGetPopularTopics, cursor: Int32? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        topicsGetPopularTopicsWithRequestBuilder(timeRange: timeRange, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get popular topics today
     - GET /v0.6/topics/popular/{timeRange}
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
     
     - parameter timeRange: (path) Time range 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseTopicView> 
     */
    open class func topicsGetPopularTopicsWithRequestBuilder(timeRange: TimeRange_topicsGetPopularTopics, cursor: Int32? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        var path = "/v0.6/topics/popular/{timeRange}"
        path = path.replacingOccurrences(of: "{timeRange}", with: "\(timeRange.rawValue)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor?.encodeToJSON(),
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseTopicView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Get topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsGetTopic(topicHandle: String, completion: @escaping ((_ data: TopicView?,_ error: Error?) -> Void)) {
        topicsGetTopicWithRequestBuilder(topicHandle: topicHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get topic
     - GET /v0.6/topics/{topicHandle}
     - examples: [{contentType=application/json, example={
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
}}, {contentType=application/xml, example=<null>
  <topicHandle>string</topicHandle>
  <createdTime>2000-01-23T04:56:07.000Z</createdTime>
  <lastUpdatedTime>2000-01-23T04:56:07.000Z</lastUpdatedTime>
  <publisherType>string</publisherType>
  <title>string</title>
  <text>string</text>
  <blobType>string</blobType>
  <blobHandle>string</blobHandle>
  <blobUrl>string</blobUrl>
  <categories>string</categories>
  <language>string</language>
  <group>string</group>
  <deepLink>string</deepLink>
  <friendlyName>string</friendlyName>
  <totalLikes>123456</totalLikes>
  <totalComments>123456</totalComments>
  <liked>true</liked>
  <pinned>true</pinned>
  <contentStatus>string</contentStatus>
</null>}]
     - examples: [{contentType=application/json, example={
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
}}, {contentType=application/xml, example=<null>
  <topicHandle>string</topicHandle>
  <createdTime>2000-01-23T04:56:07.000Z</createdTime>
  <lastUpdatedTime>2000-01-23T04:56:07.000Z</lastUpdatedTime>
  <publisherType>string</publisherType>
  <title>string</title>
  <text>string</text>
  <blobType>string</blobType>
  <blobHandle>string</blobHandle>
  <blobUrl>string</blobUrl>
  <categories>string</categories>
  <language>string</language>
  <group>string</group>
  <deepLink>string</deepLink>
  <friendlyName>string</friendlyName>
  <totalLikes>123456</totalLikes>
  <totalComments>123456</totalComments>
  <liked>true</liked>
  <pinned>true</pinned>
  <contentStatus>string</contentStatus>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 

     - returns: RequestBuilder<TopicView> 
     */
    open class func topicsGetTopicWithRequestBuilder(topicHandle: String) -> RequestBuilder<TopicView> {
        var path = "/v0.6/topics/{topicHandle}"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<TopicView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     * enum for parameter publisherType
     */
    public enum PublisherType_topicsGetTopicName: String { 
        case user = "User"
        case app = "App"
    }

    /**
     Get a topic name
     
     - parameter topicName: (path) Topic name 
     - parameter publisherType: (query) Publisher type 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsGetTopicName(topicName: String, publisherType: PublisherType_topicsGetTopicName, completion: @escaping ((_ data: GetTopicNameResponse?,_ error: Error?) -> Void)) {
        topicsGetTopicNameWithRequestBuilder(topicName: topicName, publisherType: publisherType).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get a topic name
     - GET /v0.6/topics/names/{topicName}
     - examples: [{contentType=application/json, example={
  "topicHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <topicHandle>string</topicHandle>
</null>}]
     - examples: [{contentType=application/json, example={
  "topicHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <topicHandle>string</topicHandle>
</null>}]
     
     - parameter topicName: (path) Topic name 
     - parameter publisherType: (query) Publisher type 

     - returns: RequestBuilder<GetTopicNameResponse> 
     */
    open class func topicsGetTopicNameWithRequestBuilder(topicName: String, publisherType: PublisherType_topicsGetTopicName) -> RequestBuilder<GetTopicNameResponse> {
        var path = "/v0.6/topics/names/{topicName}"
        path = path.replacingOccurrences(of: "{topicName}", with: "\(topicName)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "publisherType": publisherType.rawValue
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<GetTopicNameResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Get recent topics
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsGetTopics(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        topicsGetTopicsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get recent topics
     - GET /v0.6/topics
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
    open class func topicsGetTopicsWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/topics"
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
     Create a new topic
     
     - parameter request: (body) Post topic request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsPostTopic(request: PostTopicRequest, completion: @escaping ((_ data: PostTopicResponse?,_ error: Error?) -> Void)) {
        topicsPostTopicWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Create a new topic
     - POST /v0.6/topics
     - examples: [{contentType=application/json, example={
  "topicHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <topicHandle>string</topicHandle>
</null>}]
     - examples: [{contentType=application/json, example={
  "topicHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <topicHandle>string</topicHandle>
</null>}]
     
     - parameter request: (body) Post topic request 

     - returns: RequestBuilder<PostTopicResponse> 
     */
    open class func topicsPostTopicWithRequestBuilder(request: PostTopicRequest) -> RequestBuilder<PostTopicResponse> {
        let path = "/v0.6/topics"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<PostTopicResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Create a topic name
     
     - parameter request: (body) Post topic name request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsPostTopicName(request: PostTopicNameRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        topicsPostTopicNameWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Create a topic name
     - POST /v0.6/topics/names
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Post topic name request 

     - returns: RequestBuilder<Object> 
     */
    open class func topicsPostTopicNameWithRequestBuilder(request: PostTopicNameRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/topics/names"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Update topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter request: (body) Put topic request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsPutTopic(topicHandle: String, request: PutTopicRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        topicsPutTopicWithRequestBuilder(topicHandle: topicHandle, request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Update topic
     - PUT /v0.6/topics/{topicHandle}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 
     - parameter request: (body) Put topic request 

     - returns: RequestBuilder<Object> 
     */
    open class func topicsPutTopicWithRequestBuilder(topicHandle: String, request: PutTopicRequest) -> RequestBuilder<Object> {
        var path = "/v0.6/topics/{topicHandle}"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Update a topic name
     
     - parameter topicName: (path) Topic name 
     - parameter request: (body) Update topic name request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicsPutTopicName(topicName: String, request: PutTopicNameRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        topicsPutTopicNameWithRequestBuilder(topicName: topicName, request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Update a topic name
     - PUT /v0.6/topics/names/{topicName}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicName: (path) Topic name 
     - parameter request: (body) Update topic name request 

     - returns: RequestBuilder<Object> 
     */
    open class func topicsPutTopicNameWithRequestBuilder(topicName: String, request: PutTopicNameRequest) -> RequestBuilder<Object> {
        var path = "/v0.6/topics/names/{topicName}"
        path = path.replacingOccurrences(of: "{topicName}", with: "\(topicName)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
