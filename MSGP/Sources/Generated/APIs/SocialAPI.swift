//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class SocialAPI: APIBase {
    /**
     Unblock a user
     
     - parameter userHandle: (path) User handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myBlockedUsersDeleteBlockedUser(userHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myBlockedUsersDeleteBlockedUserWithRequestBuilder(userHandle: userHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Unblock a user
     - DELETE /v0.6/users/me/blocked_users/{userHandle}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter userHandle: (path) User handle 

     - returns: RequestBuilder<Object> 
     */
    open class func myBlockedUsersDeleteBlockedUserWithRequestBuilder(userHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/blocked_users/{userHandle}"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get my blocked users
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myBlockedUsersGetBlockedUsers(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        myBlockedUsersGetBlockedUsersWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my blocked users
     - GET /v0.6/users/me/blocked_users
     - This is a feed of users that I have blocked. Any user on this list              cannot see topics authored by me. However, any such user will see comments              and replies that I create on topics authored by other users or by the app.              Any such user will also be able to observe that activities have been performed              by users on my topics.              I will not appear in any such user's following feed, and those users will not              appear in my followers feed.              If I am following any user in this feed, that relationship will continue and I              will continue to see topics and activities by that user and I will appear in              that user's follower feed and that user will appear in my following feed.
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
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func myBlockedUsersGetBlockedUsersWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        let path = "/v0.6/users/me/blocked_users"
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
     Block a user
     
     - parameter request: (body) Post blocked user request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myBlockedUsersPostBlockedUser(request: PostBlockedUserRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myBlockedUsersPostBlockedUserWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Block a user
     - POST /v0.6/users/me/blocked_users
     - After I block a user, that user will no longer be able to see topics authored by me.              However, that user will continue to see comments and replies that I create on              topics authored by other users or by the app. That user will also be able to observe              that activities have been performed by users on my topics.              I will no longer appear in that user's following feed, and that user will no longer              appear in my followers feed.              If I am following that user, that relationship will survive and I will continue to see              topics and activities by that user and I will appear in that user's follower feed and              that user will appear in my following feed.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Post blocked user request 

     - returns: RequestBuilder<Object> 
     */
    open class func myBlockedUsersPostBlockedUserWithRequestBuilder(request: PostBlockedUserRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/blocked_users"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Remove follower
     
     - parameter userHandle: (path) User handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowersDeleteFollower(userHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myFollowersDeleteFollowerWithRequestBuilder(userHandle: userHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Remove follower
     - DELETE /v0.6/users/me/followers/{userHandle}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter userHandle: (path) User handle 

     - returns: RequestBuilder<Object> 
     */
    open class func myFollowersDeleteFollowerWithRequestBuilder(userHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/followers/{userHandle}"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get my followers
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowersGetFollowers(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        myFollowersGetFollowersWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my followers
     - GET /v0.6/users/me/followers
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
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func myFollowersGetFollowersWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        let path = "/v0.6/users/me/followers"
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
     Accept follower request
     
     - parameter request: (body) Post follower request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowersPostFollower(request: PostFollowerRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myFollowersPostFollowerWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Accept follower request
     - POST /v0.6/users/me/followers
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Post follower request 

     - returns: RequestBuilder<Object> 
     */
    open class func myFollowersPostFollowerWithRequestBuilder(request: PostFollowerRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/followers"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Unfollow a topic
     
     - parameter topicHandle: (path) Topic handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingDeleteFollowingTopic(topicHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myFollowingDeleteFollowingTopicWithRequestBuilder(topicHandle: topicHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Unfollow a topic
     - DELETE /v0.6/users/me/following/topics/{topicHandle}
     - After I unfollow a topic, that topic will no longer appear on my following topics feed.              The past and future activities on that topic will no longer appear in my following activities feed.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 

     - returns: RequestBuilder<Object> 
     */
    open class func myFollowingDeleteFollowingTopicWithRequestBuilder(topicHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/following/topics/{topicHandle}"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Unfollow a user
     
     - parameter userHandle: (path) User handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingDeleteFollowingUser(userHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myFollowingDeleteFollowingUserWithRequestBuilder(userHandle: userHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Unfollow a user
     - DELETE /v0.6/users/me/following/users/{userHandle}
     - After I unfollow a user, that user will no longer appear on my following feed.              All of that user's previous topics will be removed from my following topics feed and              none of their future topics will be added to that feed.              Their past and future activities will no longer appear in my following activities feed.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter userHandle: (path) User handle 

     - returns: RequestBuilder<Object> 
     */
    open class func myFollowingDeleteFollowingUserWithRequestBuilder(userHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/following/users/{userHandle}"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Remove a topic from my combined following topics feed.
     
     - parameter topicHandle: (path) Topic handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingDeleteTopicFromCombinedFollowingFeed(topicHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myFollowingDeleteTopicFromCombinedFollowingFeedWithRequestBuilder(topicHandle: topicHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Remove a topic from my combined following topics feed.
     - DELETE /v0.6/users/me/following/combined/{topicHandle}
     - My combined following topics feed is a feed of topics I am explicitly following, combined with topics created by all users              that I am following.  This call will remove the specified topic from that feed.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicHandle: (path) Topic handle 

     - returns: RequestBuilder<Object> 
     */
    open class func myFollowingDeleteTopicFromCombinedFollowingFeedWithRequestBuilder(topicHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/following/combined/{topicHandle}"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get the feed of activities by users that I'm following or on topics that I'm following.
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingGetActivities(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseActivityView?,_ error: Error?) -> Void)) {
        myFollowingGetActivitiesWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get the feed of activities by users that I'm following or on topics that I'm following.
     - GET /v0.6/users/me/following/activities
     - My following activity feed is a list of activities that are either              (1) performed by users that I am following, or              (2) performed on topics that I am following.              This feed is time ordered, with the most recent activity first.              An activity is added to this feed when a user I am following does one of the following 4 actions:              (a) create a comment; (b) create a reply; (c) like a topic; (d) follow a user.              If a user that I am following is deleted, then their past activities will no longer appear in this feed.              If an activity is performed on content that is then deleted, that activity will no longer appear in this feed.              If a user has un-done an activity (e.g. unlike a previous like), then that activity will no longer appear in this feed.              Similarly, an activity is added to this feed when a user does one of the following 3 actions on a topic that I am following:              (a) create a comment; (b) create a reply; (c) like the topic.              If a topic that I am following is deleted, then past activities on that topic will no longer appear in this feed.              If an activity that is performed is then deleted, that activity will no longer appear in this feed.              Ignore the unread status of each activity - it will always be true.
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "actedOnUser" : "",
    "app" : {
      "deepLink" : "aeiou",
      "name" : "aeiou",
      "platformType" : "aeiou",
      "iconUrl" : "aeiou",
      "iconHandle" : "aeiou",
      "storeLink" : "aeiou"
    },
    "actorUsers" : [ {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "aeiou",
      "visibility" : "aeiou",
      "photoHandle" : "aeiou"
    } ],
    "actedOnContent" : {
      "rootHandle" : "aeiou",
      "contentHandle" : "aeiou",
      "blobUrl" : "aeiou",
      "text" : "aeiou",
      "blobType" : "aeiou",
      "contentType" : "aeiou",
      "parentHandle" : "aeiou",
      "blobHandle" : "aeiou"
    },
    "unread" : true,
    "activityHandle" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "activityType" : "aeiou",
    "totalActions" : 123
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "actedOnUser" : "",
    "app" : {
      "deepLink" : "aeiou",
      "name" : "aeiou",
      "platformType" : "aeiou",
      "iconUrl" : "aeiou",
      "iconHandle" : "aeiou",
      "storeLink" : "aeiou"
    },
    "actorUsers" : [ {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "aeiou",
      "visibility" : "aeiou",
      "photoHandle" : "aeiou"
    } ],
    "actedOnContent" : {
      "rootHandle" : "aeiou",
      "contentHandle" : "aeiou",
      "blobUrl" : "aeiou",
      "text" : "aeiou",
      "blobType" : "aeiou",
      "contentType" : "aeiou",
      "parentHandle" : "aeiou",
      "blobHandle" : "aeiou"
    },
    "unread" : true,
    "activityHandle" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "activityType" : "aeiou",
    "totalActions" : 123
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseActivityView> 
     */
    open class func myFollowingGetActivitiesWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseActivityView> {
        let path = "/v0.6/users/me/following/activities"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor,
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseActivityView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Get the feed of topics that I am following
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingGetFollowingTopics(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        myFollowingGetFollowingTopicsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get the feed of topics that I am following
     - GET /v0.6/users/me/following/topics
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
    open class func myFollowingGetFollowingTopicsWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/users/me/following/topics"
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
     Get the feed of users that I am following
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingGetFollowingUsers(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        myFollowingGetFollowingUsersWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get the feed of users that I am following
     - GET /v0.6/users/me/following/users
     - These are the users whose topics appear on my following topics feed, and whose activities              appear on my following activities feed.
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
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func myFollowingGetFollowingUsersWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        let path = "/v0.6/users/me/following/users"
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
     Get my combined following topics feed.
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingGetTopics(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseTopicView?,_ error: Error?) -> Void)) {
        myFollowingGetTopicsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my combined following topics feed.
     - GET /v0.6/users/me/following/combined
     - My combined following topics feed includes:               (1) topics that I'm explicitly following and               (2) topics authored by users that I'm following                             This feed is time ordered, with the most recent topic first.               This feed will not include topics that I have explicitly deleted from this feed.               When I follow a user, a limited set of their past topics will be added to this feed,               and all their future topics will be added to this feed when they are created.               When I unfollow a user, all of their previous topics will be removed from the feed and               none of their future topics will be added to this feed.               When I follow a topic, it will appear in this feed.               When I unfollow a topic, it will no longer appear in this feed.
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
    open class func myFollowingGetTopicsWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseTopicView> {
        let path = "/v0.6/users/me/following/combined"
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
     Follow a topic
     
     - parameter request: (body) Post following topic request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingPostFollowingTopic(request: PostFollowingTopicRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myFollowingPostFollowingTopicWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Follow a topic
     - POST /v0.6/users/me/following/topics
     - When I follow a topic, that topic will appear on my following topics feed. When users              perform actions on the topic (such as posting comments or replies), those actions will              appear on my following activites feed.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Post following topic request 

     - returns: RequestBuilder<Object> 
     */
    open class func myFollowingPostFollowingTopicWithRequestBuilder(request: PostFollowingTopicRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/following/topics"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Follow a user
     
     - parameter request: (body) Post following user request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myFollowingPostFollowingUser(request: PostFollowingUserRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myFollowingPostFollowingUserWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Follow a user
     - POST /v0.6/users/me/following/users
     - When I follow a user, that user will appear on my following feed. That feed is              visible to all users, unless my profile is set to private, in which case only those              users that request to follow me and I approve will see that feed. If I try to follow a              user with a private profile, then that private user controls whether I am allowed to              follow them or not.              That user's topics will appear in my following topics feed and actions              performed by that user will also appear in my following activities feed.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Post following user request 

     - returns: RequestBuilder<Object> 
     */
    open class func myFollowingPostFollowingUserWithRequestBuilder(request: PostFollowingUserRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/following/users"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Reject follower request
     
     - parameter userHandle: (path) User handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPendingUsersDeletePendingUser(userHandle: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myPendingUsersDeletePendingUserWithRequestBuilder(userHandle: userHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Reject follower request
     - DELETE /v0.6/users/me/pending_users/{userHandle}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter userHandle: (path) User handle 

     - returns: RequestBuilder<Object> 
     */
    open class func myPendingUsersDeletePendingUserWithRequestBuilder(userHandle: String) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/pending_users/{userHandle}"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get my pending users
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPendingUsersGetPendingUsers(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        myPendingUsersGetPendingUsersWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my pending users
     - GET /v0.6/users/me/pending_users
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
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func myPendingUsersGetPendingUsersWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        let path = "/v0.6/users/me/pending_users"
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
     Get my pending users count
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPendingUsersGetPendingUsersCount(completion: @escaping ((_ data: CountResponse?,_ error: Error?) -> Void)) {
        myPendingUsersGetPendingUsersCountWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my pending users count
     - GET /v0.6/users/me/pending_users/count
     - examples: [{contentType=application/json, example={
  "count" : 123456789
}}, {contentType=application/xml, example=<null>
  <count>123456</count>
</null>}]
     - examples: [{contentType=application/json, example={
  "count" : 123456789
}}, {contentType=application/xml, example=<null>
  <count>123456</count>
</null>}]

     - returns: RequestBuilder<CountResponse> 
     */
    open class func myPendingUsersGetPendingUsersCountWithRequestBuilder() -> RequestBuilder<CountResponse> {
        let path = "/v0.6/users/me/pending_users/count"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<CountResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Get followers of a user
     
     - parameter userHandle: (path) User handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func userFollowersGetFollowers(userHandle: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        userFollowersGetFollowersWithRequestBuilder(userHandle: userHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get followers of a user
     - GET /v0.6/users/{userHandle}/followers
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
     
     - parameter userHandle: (path) User handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func userFollowersGetFollowersWithRequestBuilder(userHandle: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        var path = "/v0.6/users/{userHandle}/followers"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
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
     Get following users of a user
     
     - parameter userHandle: (path) User handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func userFollowingGetFollowing(userHandle: String, cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseUserCompactView?,_ error: Error?) -> Void)) {
        userFollowingGetFollowingWithRequestBuilder(userHandle: userHandle, cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get following users of a user
     - GET /v0.6/users/{userHandle}/following
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
     
     - parameter userHandle: (path) User handle 
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseUserCompactView> 
     */
    open class func userFollowingGetFollowingWithRequestBuilder(userHandle: String, cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseUserCompactView> {
        var path = "/v0.6/users/{userHandle}/following"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
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

}
