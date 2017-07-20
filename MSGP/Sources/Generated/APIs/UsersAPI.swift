//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class UsersAPI: APIBase {
    /**
     Find users the current user is following in another app but not in the current app
     
     - parameter appHandle: (path) App handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myAppFollowingGetUsers(appHandle: String, cursor: String? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        myAppFollowingGetUsersWithRequestBuilder(appHandle: appHandle, cursor: cursor).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Find users the current user is following in another app but not in the current app
     - GET /v0.6/users/me/apps/{appHandle}/following/difference
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
     
     - parameter appHandle: (path) App handle 
     - parameter cursor: (query) Current read cursor (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func myAppFollowingGetUsersWithRequestBuilder(appHandle: String, cursor: String? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        var path = "/v0.6/users/me/apps/{appHandle}/following/difference"
        path = path.replacingOccurrences(of: "{appHandle}", with: "\(appHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseUserCompactView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Get my list of Social Plus apps
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myAppsGetApps(completion: @escaping ((_ data: [AppCompactView]?,_ error: Error?) -> Void)) {
        myAppsGetAppsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my list of Social Plus apps
     - GET /v0.6/users/me/apps
     - examples: [{contentType=application/json, example=[ {
  "deepLink" : "aeiou",
  "name" : "aeiou",
  "platformType" : "aeiou",
  "iconUrl" : "aeiou",
  "iconHandle" : "aeiou",
  "storeLink" : "aeiou"
} ]}, {contentType=application/xml, example=<null>
  <name>string</name>
  <iconHandle>string</iconHandle>
  <iconUrl>string</iconUrl>
  <platformType>string</platformType>
  <deepLink>string</deepLink>
  <storeLink>string</storeLink>
</null>}]
     - examples: [{contentType=application/json, example=[ {
  "deepLink" : "aeiou",
  "name" : "aeiou",
  "platformType" : "aeiou",
  "iconUrl" : "aeiou",
  "iconHandle" : "aeiou",
  "storeLink" : "aeiou"
} ]}, {contentType=application/xml, example=<null>
  <name>string</name>
  <iconHandle>string</iconHandle>
  <iconUrl>string</iconUrl>
  <platformType>string</platformType>
  <deepLink>string</deepLink>
  <storeLink>string</storeLink>
</null>}]

     - returns: RequestBuilder<[AppCompactView]> 
     */
    open class func myAppsGetAppsWithRequestBuilder() -> RequestBuilder<[AppCompactView]> {
        let path = "/v0.6/users/me/apps"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<[AppCompactView]>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get my liked topics.
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myLikesGetLikedTopics(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        myLikesGetLikedTopicsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my liked topics.
     - GET /v0.6/users/me/likes/topics
     - Not yet implemented.
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
    open class func myLikesGetLikedTopicsWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/users/me/likes/topics"
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
     * enum for parameter identityProvider
     */
    public enum IdentityProvider_myLinkedAccountsDeleteLinkedAccount: String { 
        case facebook = "Facebook"
        case microsoft = "Microsoft"
        case google = "Google"
        case twitter = "Twitter"
        case aads2s = "AADS2S"
        case socialPlus = "SocialPlus"
    }

    /**
     Delete linked account
     
     - parameter identityProvider: (path) Identity provider type 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myLinkedAccountsDeleteLinkedAccount(identityProvider: IdentityProvider_myLinkedAccountsDeleteLinkedAccount, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myLinkedAccountsDeleteLinkedAccountWithRequestBuilder(identityProvider: identityProvider).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Delete linked account
     - DELETE /v0.6/users/me/linked_accounts/{identityProvider}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter identityProvider: (path) Identity provider type 

     - returns: RequestBuilder<Object> 
     */
    open class func myLinkedAccountsDeleteLinkedAccountWithRequestBuilder(identityProvider: IdentityProvider_myLinkedAccountsDeleteLinkedAccount) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/linked_accounts/{identityProvider}"
        path = path.replacingOccurrences(of: "{identityProvider}", with: "\(identityProvider.rawValue)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get linked accounts. Each user has at least two linked accounts: one SocialPlus account, and one (or more) third-party account.
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myLinkedAccountsGetLinkedAccounts(completion: @escaping ((_ data: [LinkedAccountView]?,_ error: Error?) -> Void)) {
        myLinkedAccountsGetLinkedAccountsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get linked accounts. Each user has at least two linked accounts: one SocialPlus account, and one (or more) third-party account.
     - GET /v0.6/users/me/linked_accounts
     - examples: [{contentType=application/json, example=[ {
  "accountId" : "aeiou",
  "identityProvider" : "aeiou"
} ]}, {contentType=application/xml, example=<null>
  <identityProvider>string</identityProvider>
  <accountId>string</accountId>
</null>}]
     - examples: [{contentType=application/json, example=[ {
  "accountId" : "aeiou",
  "identityProvider" : "aeiou"
} ]}, {contentType=application/xml, example=<null>
  <identityProvider>string</identityProvider>
  <accountId>string</accountId>
</null>}]

     - returns: RequestBuilder<[LinkedAccountView]> 
     */
    open class func myLinkedAccountsGetLinkedAccountsWithRequestBuilder() -> RequestBuilder<[LinkedAccountView]> {
        let path = "/v0.6/users/me/linked_accounts"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<[LinkedAccountView]>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Create a new linked account.              The account to be linked must appear in the Auth header of the request. This new third-party account              will be linked against the credentials appearing in the session token passed in the body of the request.
     
     - parameter request: (body) Post linked account request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myLinkedAccountsPostLinkedAccount(request: PostLinkedAccountRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myLinkedAccountsPostLinkedAccountWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Create a new linked account.              The account to be linked must appear in the Auth header of the request. This new third-party account              will be linked against the credentials appearing in the session token passed in the body of the request.
     - POST /v0.6/users/me/linked_accounts
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Post linked account request 

     - returns: RequestBuilder<Object> 
     */
    open class func myLinkedAccountsPostLinkedAccountWithRequestBuilder(request: PostLinkedAccountRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/linked_accounts"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get my topics sorted by popularity
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myTopicsGetPopularTopics(cursor: Int32? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        myTopicsGetPopularTopicsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my topics sorted by popularity
     - GET /v0.6/users/me/topics/popular
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
    open class func myTopicsGetPopularTopicsWithRequestBuilder(cursor: Int32? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/users/me/topics/popular"
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
     Get my topics sorted by creation time
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myTopicsGetTopics(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        myTopicsGetTopicsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my topics sorted by creation time
     - GET /v0.6/users/me/topics
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
    open class func myTopicsGetTopicsWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/users/me/topics"
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
     Get user topics sorted by popularity
     
     - parameter userHandle: (path) User handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func userTopicsGetPopularTopics(userHandle: String, cursor: Int32? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        userTopicsGetPopularTopicsWithRequestBuilder(userHandle: userHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get user topics sorted by popularity
     - GET /v0.6/users/{userHandle}/topics/popular
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
     
     - parameter userHandle: (path) User handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseTopicView> 
     */
    open class func userTopicsGetPopularTopicsWithRequestBuilder(userHandle: String, cursor: Int32? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        var path = "/v0.6/users/{userHandle}/topics/popular"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
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
     Get user topics sorted by creation time
     
     - parameter userHandle: (path) User handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func userTopicsGetTopics(userHandle: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        userTopicsGetTopicsWithRequestBuilder(userHandle: userHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get user topics sorted by creation time
     - GET /v0.6/users/{userHandle}/topics
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
     
     - parameter userHandle: (path) User handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseTopicView> 
     */
    open class func userTopicsGetTopicsWithRequestBuilder(userHandle: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        var path = "/v0.6/users/{userHandle}/topics"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
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
     Delete user
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersDeleteUser(completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        usersDeleteUserWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Delete user
     - DELETE /v0.6/users/me
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]

     - returns: RequestBuilder<Object> 
     */
    open class func usersDeleteUserWithRequestBuilder() -> RequestBuilder<Object> {
        let path = "/v0.6/users/me"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get my profile
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersGetMyProfile(completion: @escaping ((_ data: UserProfileView?,_ error: Error?) -> Void)) {
        usersGetMyProfileWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my profile
     - GET /v0.6/users/me
     - examples: [{contentType=application/json, example={
  "userHandle" : "aeiou",
  "followingStatus" : "aeiou",
  "lastName" : "aeiou",
  "followerStatus" : "aeiou",
  "visibility" : "aeiou",
  "totalFollowing" : 123456789,
  "profileStatus" : "aeiou",
  "bio" : "aeiou",
  "photoHandle" : "aeiou",
  "firstName" : "aeiou",
  "photoUrl" : "aeiou",
  "totalFollowers" : 123456789,
  "totalTopics" : 123456789
}}, {contentType=application/xml, example=<null>
  <userHandle>string</userHandle>
  <firstName>string</firstName>
  <lastName>string</lastName>
  <bio>string</bio>
  <photoHandle>string</photoHandle>
  <photoUrl>string</photoUrl>
  <visibility>string</visibility>
  <totalTopics>123456</totalTopics>
  <totalFollowers>123456</totalFollowers>
  <totalFollowing>123456</totalFollowing>
  <followerStatus>string</followerStatus>
  <followingStatus>string</followingStatus>
  <profileStatus>string</profileStatus>
</null>}]
     - examples: [{contentType=application/json, example={
  "userHandle" : "aeiou",
  "followingStatus" : "aeiou",
  "lastName" : "aeiou",
  "followerStatus" : "aeiou",
  "visibility" : "aeiou",
  "totalFollowing" : 123456789,
  "profileStatus" : "aeiou",
  "bio" : "aeiou",
  "photoHandle" : "aeiou",
  "firstName" : "aeiou",
  "photoUrl" : "aeiou",
  "totalFollowers" : 123456789,
  "totalTopics" : 123456789
}}, {contentType=application/xml, example=<null>
  <userHandle>string</userHandle>
  <firstName>string</firstName>
  <lastName>string</lastName>
  <bio>string</bio>
  <photoHandle>string</photoHandle>
  <photoUrl>string</photoUrl>
  <visibility>string</visibility>
  <totalTopics>123456</totalTopics>
  <totalFollowers>123456</totalFollowers>
  <totalFollowing>123456</totalFollowing>
  <followerStatus>string</followerStatus>
  <followingStatus>string</followingStatus>
  <profileStatus>string</profileStatus>
</null>}]

     - returns: RequestBuilder<UserProfileView> 
     */
    open class func usersGetMyProfileWithRequestBuilder() -> RequestBuilder<UserProfileView> {
        let path = "/v0.6/users/me"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<UserProfileView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get popular users
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersGetPopularUsers(cursor: Int32? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserProfileView?,_ error: Error?) -> Void)) {
        usersGetPopularUsersWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get popular users
     - GET /v0.6/users/popular
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "userHandle" : "aeiou",
    "followingStatus" : "aeiou",
    "lastName" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "totalFollowing" : 123456789,
    "profileStatus" : "aeiou",
    "bio" : "aeiou",
    "photoHandle" : "aeiou",
    "firstName" : "aeiou",
    "photoUrl" : "aeiou",
    "totalFollowers" : 123456789,
    "totalTopics" : 123456789
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "userHandle" : "aeiou",
    "followingStatus" : "aeiou",
    "lastName" : "aeiou",
    "followerStatus" : "aeiou",
    "visibility" : "aeiou",
    "totalFollowing" : 123456789,
    "profileStatus" : "aeiou",
    "bio" : "aeiou",
    "photoHandle" : "aeiou",
    "firstName" : "aeiou",
    "photoUrl" : "aeiou",
    "totalFollowers" : 123456789,
    "totalTopics" : 123456789
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserProfileView> 
     */
    open class func usersGetPopularUsersWithRequestBuilder(cursor: Int32? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserProfileView> {
        let path = "/v0.6/users/popular"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor?.encodeToJSON(),
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseUserProfileView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Get user profile
     
     - parameter userHandle: (path) User handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersGetUser(userHandle: String, completion: @escaping ((_ data: UserProfileView?,_ error: Error?) -> Void)) {
        usersGetUserWithRequestBuilder(userHandle: userHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get user profile
     - GET /v0.6/users/{userHandle}
     - examples: [{contentType=application/json, example={
  "userHandle" : "aeiou",
  "followingStatus" : "aeiou",
  "lastName" : "aeiou",
  "followerStatus" : "aeiou",
  "visibility" : "aeiou",
  "totalFollowing" : 123456789,
  "profileStatus" : "aeiou",
  "bio" : "aeiou",
  "photoHandle" : "aeiou",
  "firstName" : "aeiou",
  "photoUrl" : "aeiou",
  "totalFollowers" : 123456789,
  "totalTopics" : 123456789
}}, {contentType=application/xml, example=<null>
  <userHandle>string</userHandle>
  <firstName>string</firstName>
  <lastName>string</lastName>
  <bio>string</bio>
  <photoHandle>string</photoHandle>
  <photoUrl>string</photoUrl>
  <visibility>string</visibility>
  <totalTopics>123456</totalTopics>
  <totalFollowers>123456</totalFollowers>
  <totalFollowing>123456</totalFollowing>
  <followerStatus>string</followerStatus>
  <followingStatus>string</followingStatus>
  <profileStatus>string</profileStatus>
</null>}]
     - examples: [{contentType=application/json, example={
  "userHandle" : "aeiou",
  "followingStatus" : "aeiou",
  "lastName" : "aeiou",
  "followerStatus" : "aeiou",
  "visibility" : "aeiou",
  "totalFollowing" : 123456789,
  "profileStatus" : "aeiou",
  "bio" : "aeiou",
  "photoHandle" : "aeiou",
  "firstName" : "aeiou",
  "photoUrl" : "aeiou",
  "totalFollowers" : 123456789,
  "totalTopics" : 123456789
}}, {contentType=application/xml, example=<null>
  <userHandle>string</userHandle>
  <firstName>string</firstName>
  <lastName>string</lastName>
  <bio>string</bio>
  <photoHandle>string</photoHandle>
  <photoUrl>string</photoUrl>
  <visibility>string</visibility>
  <totalTopics>123456</totalTopics>
  <totalFollowers>123456</totalFollowers>
  <totalFollowing>123456</totalFollowing>
  <followerStatus>string</followerStatus>
  <followingStatus>string</followingStatus>
  <profileStatus>string</profileStatus>
</null>}]
     
     - parameter userHandle: (path) User handle 

     - returns: RequestBuilder<UserProfileView> 
     */
    open class func usersGetUserWithRequestBuilder(userHandle: String) -> RequestBuilder<UserProfileView> {
        var path = "/v0.6/users/{userHandle}"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<UserProfileView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Create a new user
     
     - parameter request: (body) Post user request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersPostUser(request: PostUserRequest, completion: @escaping ((_ data: PostUserResponse?,_ error: Error?) -> Void)) {
        usersPostUserWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Create a new user
     - POST /v0.6/users
     - Create a new user and return a fresh session token
     - examples: [{contentType=application/json, example={
  "userHandle" : "aeiou",
  "sessionToken" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <userHandle>string</userHandle>
  <sessionToken>string</sessionToken>
</null>}]
     - examples: [{contentType=application/json, example={
  "userHandle" : "aeiou",
  "sessionToken" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <userHandle>string</userHandle>
  <sessionToken>string</sessionToken>
</null>}]
     
     - parameter request: (body) Post user request 

     - returns: RequestBuilder<PostUserResponse> 
     */
    open class func usersPostUserWithRequestBuilder(request: PostUserRequest) -> RequestBuilder<PostUserResponse> {
        let path = "/v0.6/users"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<PostUserResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Update user info
     
     - parameter request: (body) Put user info request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersPutUserInfo(request: PutUserInfoRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        usersPutUserInfoWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Update user info
     - PUT /v0.6/users/me/info
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Put user info request 

     - returns: RequestBuilder<Object> 
     */
    open class func usersPutUserInfoWithRequestBuilder(request: PutUserInfoRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/info"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Update user photo
     
     - parameter request: (body) Put user photo request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersPutUserPhoto(request: PutUserPhotoRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        usersPutUserPhotoWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Update user photo
     - PUT /v0.6/users/me/photo
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Put user photo request 

     - returns: RequestBuilder<Object> 
     */
    open class func usersPutUserPhotoWithRequestBuilder(request: PutUserPhotoRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/photo"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Update user visibility
     
     - parameter request: (body) Put user visibility request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func usersPutUserVisibility(request: PutUserVisibilityRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        usersPutUserVisibilityWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Update user visibility
     - PUT /v0.6/users/me/visibility
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Put user visibility request 

     - returns: RequestBuilder<Object> 
     */
    open class func usersPutUserVisibilityWithRequestBuilder(request: PutUserVisibilityRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/visibility"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
