//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class SearchAPI: APIBase {
    /**
     Search topics with a query
     
     - parameter query: (query) Search query 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func searchGetTopics(query: String, cursor: Int32? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        searchGetTopicsWithRequestBuilder(query: query, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Search topics with a query
     - GET /v0.6/search/topics
     - The query string will be searched across hashtags, topic titles, and topic texts,               and matching results will be returned.                             If the query string contains only hashtags, e.g. #foo #bar, then only the hashtags               in topics will be searched.                             Query string supports the following operators:               - suffix: \"foo*\"               - and: \"foo+bar\"               - or: \"foo|bar\"               - not: \"-foo\"               - phrase: \"\"foo bar\"\"               - precedence: \"foo+(bar|baz)\"               You need to escape * if it is at the end of a word, and - if it is at the start of a word.               Default behavior is to use and, so if you use whitespace to separate words,               such as \"foo bar\", that is equivalent to \"foo+bar\".
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
     
     - parameter query: (query) Search query 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseTopicView> 
     */
    open class func searchGetTopicsWithRequestBuilder(query: String, cursor: Int32? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/search/topics"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "query": query,
            "cursor": cursor?.encodeToJSON(),
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseTopicView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Search users with a query
     
     - parameter query: (query) Search query 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func searchGetUsers(query: String, cursor: Int32? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        searchGetUsersWithRequestBuilder(query: query, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Search users with a query
     - GET /v0.6/search/users
     - The query string will be searched across the full name of users               and matching results will be returned.                             Query string supports the following operators:               - suffix: \"foo*\"               - and: \"foo+bar\"               - or: \"foo|bar\"               - not: \"-foo\"               - phrase: \"\"foo bar\"\"               - precedence: \"foo+(bar|baz)\"               You need to escape * if it is at the end of a word, and - if it is at the start of a word.               Default behavior is to use and, so if you use whitespace to separate words,               such as \"foo bar\", that is equivalent to \"foo+bar\".
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
     
     - parameter query: (query) Search query 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func searchGetUsersWithRequestBuilder(query: String, cursor: Int32? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        let path = "/v0.6/search/users"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "query": query,
            "cursor": cursor?.encodeToJSON(),
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseUserCompactView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

}
